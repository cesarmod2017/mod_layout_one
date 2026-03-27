# Flow Generation — Regras de Persistência Física e Qualidade de Conteúdo

## Objetivo

Este documento define as regras **obrigatórias e inegociáveis** para a geração de arquivos `.claude/` (agents, commands, skills) durante a execução do Super Architect e de qualquer outro agente que crie infraestrutura de times de IA. O objetivo é **garantir que os arquivos sejam efetivamente persistidos no disco** e que o **conteúdo seja altamente especializado, completo e baseado no código real do projeto**.

> **REGRA FUNDAMENTAL**: O Claude Code CLI lê arquivos **DO DISCO**. Se um artefato (agent, command, skill) não existir como arquivo `.md` físico no diretório `.claude/` do projeto, ele **NÃO FUNCIONA**, independente de estar registrado no banco de dados via MCP. A dupla escrita (disco + MCP) é **obrigatória e sem exceção**.

---

## 1. Persistência Física Obrigatória

### 1.1 O Problema

O pipeline atual tem falhado em dois pontos críticos:

1. **Arquivos não são criados no disco** — O agente chama o MCP (CreateAgent, CreateSkill, etc.) mas não usa a tool `Write` para criar o arquivo `.md` no filesystem. Resultado: o registro existe no banco mas o CLI não encontra nada.
2. **Conteúdo genérico** — Quando os arquivos são criados, o conteúdo é superficial, com descrições vagas tipo "Você é um especialista em X" sem nenhuma regra, exemplo ou referência do projeto real. Resultado: times de IA que produzem código inconsistente e de baixa qualidade.

### 1.2 Regra de Dupla Escrita (Write + MCP)

Para **CADA** artefato gerado, são obrigatórias **duas operações** na seguinte ordem estrita:

```
PASSO 1: ESCREVER NO DISCO
   → Tool: Write
   → Path: {ProjectPath}/.claude/{tipo}/{nome}.md (ou {nome}/SKILL.md para skills)
   → Conteúdo: .md COMPLETO com frontmatter YAML + corpo detalhado

PASSO 2: REGISTRAR NO BANCO (ver .claude/kyroon/mcp-kyroon.md para parâmetros completos)
   → Call MCP Kyroon - CreateAgent / CreateSkill / CreateCommand
   → Parâmetro contentMd: MESMO conteúdo escrito no disco
   → Parâmetro flowId: ID do flow criado no STEP 2 do protocolo
```

**NUNCA** fazer apenas a chamada MCP sem escrever o arquivo.
**NUNCA** escrever o arquivo sem registrar no MCP.
**NUNCA** usar conteúdo diferente no disco e no MCP.

### 1.3 Caminhos Obrigatórios

Todos os caminhos são relativos ao `ProjectPath` fornecido no contexto de execução:

| Artefato | Caminho no disco | Formato |
|----------|-----------------|---------|
| Agent | `{ProjectPath}/.claude/agents/{prefix}_{agent-name}.md` | Arquivo flat `.md` |
| Command | `{ProjectPath}/.claude/commands/{prefix}_{command-name}.md` | Arquivo flat `.md` |
| Skill | `{ProjectPath}/.claude/skills/{prefix}_{skill-name}/SKILL.md` | Diretório com `SKILL.md` |

> **Flow-scoped naming**: `{prefix}` = primeiros 8 caracteres hexadecimais do `flowId` (sem hífens).
> Exemplo: flowId `a1b2c3d4-5678-...` → prefix `a1b2c3d4` → `.claude/agents/a1b2c3d4_orchestrator.md`.
> Isso garante que múltiplos flows no mesmo projeto não colidam em nomes de arquivo.
> O servidor aplica o prefixo automaticamente no `name` técnico ao chamar CreateAgent/CreateSkill/CreateCommand.
> Passe o nome ORIGINAL (sem prefixo) no parâmetro `name` do MCP. Use o nome PREFIXADO no caminho do disco.

### 1.4 Criação de Diretórios (ANTES de qualquer Write)

Antes de escrever qualquer arquivo, **SEMPRE** garantir que a estrutura de diretórios existe:

```bash
mkdir -p "{ProjectPath}/.claude/agents"
mkdir -p "{ProjectPath}/.claude/commands"
mkdir -p "{ProjectPath}/.claude/skills/{prefix}_{skill-name}"
```

> **DICA**: Execute todos os `mkdir -p` de uma vez no início do processo, antes de começar a escrever arquivos.

### 1.5 Verificação Pós-Escrita (OBRIGATÓRIA)

Após CADA `Write`, o agente **DEVE** verificar que o arquivo foi criado e não está vazio:

```bash
# Verificar existência e tamanho (use o nome PREFIXADO)
ls -la "{ProjectPath}/.claude/agents/{prefix}_{agent-name}.md"

# Verificar número de linhas (mínimos por tipo)
wc -l "{ProjectPath}/.claude/agents/{prefix}_{agent-name}.md"
```

**Tamanhos mínimos obrigatórios:**

| Tipo | Linhas mínimas | Justificativa |
|------|---------------|---------------|
| Agent | 150 linhas | Identity + Responsibilities + Rules + Examples + Common Mistakes |
| Command | 100 linhas | Usage + Execution Flow + Approval Gates + Rollback + Output |
| Skill | 200 linhas | Padrões reais + 3-5 exemplos de código completo + Anti-patterns |

Se o arquivo tiver **menos linhas que o mínimo**, o conteúdo está incompleto e DEVE ser reescrito antes de continuar.

### 1.6 Caminhos PROIBIDOS

Os seguintes caminhos são **PROIBIDOS** para criação de arquivos `.claude/`:

- ❌ Diretório do MCP Server (`Kyroon.Enterprise.Server.Worker/.claude/`)
- ❌ Diretório do backend solution root quando o ProjectPath é outro
- ❌ Diretório home do usuário (`~/.claude/` ou `C:\Users\*\.claude\`)
- ❌ Qualquer caminho que não seja `{ProjectPath}/.claude/`
- ❌ Dentro de `node_modules/`, `bin/`, `obj/`, `.git/`

### 1.7 Sequência Completa de Persistência (Exemplo Real)

```
# EXEMPLO: Criando o agent "dotnet-specialist"

# 1. Criar diretório (se ainda não existe)
Bash: mkdir -p "{ProjectPath}/.claude/agents"

# 2. Gerar conteúdo completo em memória (150+ linhas)
# [O agente monta o conteúdo .md completo com frontmatter + corpo]

# 3. Escrever no disco
Write: file_path="{ProjectPath}/.claude/agents/dotnet-specialist.md"
       content="---\nname: dotnet-specialist\n..."

# 4. Verificar existência
Bash: wc -l "{ProjectPath}/.claude/agents/dotnet-specialist.md"
# Output esperado: "187 .claude/agents/dotnet-specialist.md"

# 5. Registrar no MCP (ver .claude/kyroon/mcp-kyroon.md para parâmetros completos)
# → Call MCP Kyroon - CreateAgent com: workspaceId, projectId, name, type, description, contentMd (MESMO do passo 3), model, flowId

# 6. Logar progresso
# → Call MCP Kyroon - LogSubtask com: subtaskId, level: "info", message: "Agent dotnet-specialist criado: 187 linhas, 22 regras"

# 7. Registrar diff
# → Call MCP Kyroon - AttachDiff com: subtaskId, filePath, diff, action: "created"
```

---

## 2. Qualidade de Conteúdo — Times Especialistas de Verdade

### 2.1 O Problema Atual

Os agentes gerados tendem a ser **genéricos demais**:

| Problema | Exemplo Ruim | Impacto |
|----------|-------------|---------|
| Descrição vaga | "Especialista em .NET" | Agent não sabe QUAIS padrões seguir |
| Sem regras | Rules com 3 items genéricos | Agent gera código inconsistente |
| Sem exemplos | Nenhum código real referenciado | Agent inventa padrões que não existem no projeto |
| Sem anti-patterns | Não documenta erros comuns | Agent repete erros conhecidos |
| Sem referências | Não lista arquivos modelo | Agent não tem base para imitar |
| Skills superficiais | Template com `{Domain}` placeholder | Skill não ensina o padrão REAL, só o formato |

### 2.2 Regra de Ouro

> **Cada arquivo .md gerado DEVE conter conhecimento suficiente para que um desenvolvedor humano novo no projeto (ou um LLM sem contexto prévio) consiga trabalhar seguindo exatamente os padrões existentes, sem precisar ler mais nenhum arquivo do projeto.**

Isso significa que o conteúdo deve ser **autocontido** e **exaustivo**.

### 2.3 Processo de Extração de Conhecimento (ANTES de Gerar)

O Super Architect **DEVE** seguir este processo para cada artefato:

```
PARA CADA AGENT:
  1. Identificar quais camadas/arquivos este agent gerencia
  2. Ler MÍNIMO 3 arquivos reais de cada camada
  3. Extrair: naming conventions, imports, patterns, error handling
  4. Identificar: dependências injetadas, base classes, interfaces
  5. Documentar: anti-patterns encontrados (code smells, workarounds)
  6. Só ENTÃO gerar o conteúdo do agent

PARA CADA SKILL:
  1. Identificar o domínio de conhecimento
  2. Ler MÍNIMO 5 arquivos reais que exemplificam o padrão
  3. Copiar código COMPLETO (não resumido) como exemplos
  4. Documentar o PORQUÊ de cada decisão arquitetural
  5. Comparar 2+ implementações para extrair o padrão comum
  6. Documentar variações aceitas vs. anti-patterns
  7. Só ENTÃO gerar o conteúdo da skill

PARA CADA COMMAND:
  1. Mapear o fluxo COMPLETO que o command deve executar
  2. Identificar TODOS os agents envolvidos e a ordem de execução
  3. Identificar TODOS os arquivos que serão criados/modificados
  4. Definir approval gates com critérios claros
  5. Definir rollback strategy para cada fase
  6. Criar exemplos de uso REAIS (não hipotéticos)
  7. Só ENTÃO gerar o conteúdo do command
```

---

## 3. Requisitos Mínimos por Tipo de Artefato

### 3.1 AGENTS — Definição Completa de Especialistas

Um agent **NÃO** pode ser apenas "Você é um especialista em X". Ele **DEVE** conter TODAS as seções abaixo:

#### Seção: Identity (OBRIGATÓRIA — 5-8 frases)

- Papel específico no time com tecnologias exatas e versões
- O que ele FAZ (escopo positivo)
- O que ele **NÃO FAZ** (escopo negativo — delimitação clara)
- De quem ele recebe trabalho e para quem entrega
- Qual é seu critério de "pronto" (definition of done)

**RUIM:**
```
Você é um especialista em .NET que implementa serviços.
```

**BOM:**
```
Você é o especialista em backend .NET 8 do time de IA do Kyroon Enterprise Server.
Sua especialidade é implementar gRPC services (thin services com FlowStepsChain),
command handlers (interface ICommand), e extensões de DI.

Você recebe: arquivo .proto já criado pelo orchestrator + entity model do database-specialist.
Você entrega: service class + handlers CRUD + DI extension + atualização do Program.cs.

Você NÃO cria entidades de banco (responsabilidade do database-specialist).
Você NÃO cria arquivos .proto (responsabilidade do orchestrator).
Você NÃO escreve testes (responsabilidade do qa-specialist).
Você NÃO modifica o ApplicationDbContext (responsabilidade do database-specialist).

Seu critério de "pronto": todos handlers compilam, estão registrados no DI,
o service está mapeado no Program.cs, e o `dotnet build` passa sem erros.
```

#### Seção: Responsibilities (OBRIGATÓRIA — 7-12 itens)

Cada responsabilidade deve ter:
- Ação específica (verbo + objeto)
- Artefato de saída (arquivo/mudança)
- Padrão a seguir (referência ao code real)

**RUIM:**
```
1. Implementar serviços
2. Criar handlers
3. Configurar DI
```

**BOM:**
```
1. **Criar gRPC Service classes** — Thin services que usam `FlowStepsChain` para
   delegar a handlers. Zero lógica de negócio no service. Sempre com `[Authorize]`
   no class-level. Modelo: `CommandGrpcService.cs`.

2. **Criar Command Handlers (CRUD)** — Um handler por operação (Create, Update,
   Delete, Get, List, Dropdown, Sync), cada um implementando `ICommand`.
   Modelo: `CommandCreateHandler.cs` para Create, `AgentSyncHandler.cs` para Sync.

3. **Implementar UUID deduplication** — Todo CreateHandler DEVE verificar se
   `request.Uuid` já existe antes de criar nova entidade. Isso suporta o
   cenário offline-first onde o mesmo request pode chegar múltiplas vezes.
   Código padrão:
   var existing = await _db.{Entities}.FirstOrDefaultAsync(e =>
     e.ClientUuid == Guid.Parse(request.Uuid) && e.WorkspaceId == workspaceId);
   if (existing != null) return (true, MapToDto(existing));
```

#### Seção: Input/Output (OBRIGATÓRIA — detalhado)

```
## Input
- Arquivo `.proto` já criado (contrato gRPC com todos RPCs definidos)
  → Exemplo: `Core/Protos/Command/command.proto`
- Entity model criado (C# class com properties e tipos)
  → Exemplo: `Data/Models/Kyroon/Command.cs`
- Map criado (Fluent API configuration)
  → Exemplo: `Data/Models/Kyroon/Maps/CommandMap.cs`
- IDs de contexto MCP: workspaceId, projectId, taskId, subtaskId
- Nome do domínio em PascalCase (ex: "Medication", "Appointment")

## Output
- `Core/Services/{Domain}/{Domain}GrpcService.cs`
- `Core/Services/{Domain}/{Domain}ServiceExtensions.cs`
- `Core/Services/{Domain}/Create{Domain}/{Domain}CreateHandler.cs`
- `Core/Services/{Domain}/Update{Domain}/{Domain}UpdateHandler.cs`
- `Core/Services/{Domain}/Delete{Domain}/{Domain}DeleteHandler.cs`
- `Core/Services/{Domain}/Get{Domain}/{Domain}GetHandler.cs`
- `Core/Services/{Domain}/List{Domain}s/{Domain}ListHandler.cs`
- `Core/Services/{Domain}/Dropdown{Domain}s/{Domain}DropdownHandler.cs`
- `Core/Services/{Domain}/Sync{Domain}s/{Domain}SyncHandler.cs`
- Modificação: `Program.cs` (+2 linhas: DI + MapGrpcService)
```

#### Seção: File Creation Checklist (OBRIGATÓRIA)

Árvore **completa** de arquivos com caminhos REAIS do projeto:

```
## File Creation Checklist

Para cada novo domínio "{Domain}", este agent cria:

Core/Services/{Domain}/
├── {Domain}GrpcService.cs              ← Thin service (delegação via FlowStepsChain)
├── {Domain}ServiceExtensions.cs        ← DI registration (AddScoped para cada handler)
├── Create{Domain}/
│   └── {Domain}CreateHandler.cs        ← ICommand — UUID dedup + entity creation
├── Update{Domain}/
│   └── {Domain}UpdateHandler.cs        ← ICommand — soft delete check + update
├── Delete{Domain}/
│   └── {Domain}DeleteHandler.cs        ← ICommand — soft delete (IsDeleted = true)
├── Get{Domain}/
│   └── {Domain}GetHandler.cs           ← ICommand — busca por ID + workspace filter
├── List{Domain}s/
│   └── {Domain}ListHandler.cs          ← ICommand — paginação + filtros + workspace
├── Dropdown{Domain}s/
│   └── {Domain}DropdownHandler.cs      ← ICommand — ID + Name apenas
└── Sync{Domain}s/
    └── {Domain}SyncHandler.cs          ← ICommand — incremental sync

Modificações em arquivos existentes:
├── Program.cs                          ← +1 linha: builder.Services.Add{Domain}Handlers();
│                                       ← +1 linha: app.MapGrpcService<{Domain}GrpcService>()...
└── Kyroon.Enterprise.Server.Core.csproj ← +1 linha: <Protobuf Include="..." /> (se proto novo)
```

#### Seção: Rules (OBRIGATÓRIA — 15-25 regras agrupadas)

Regras **DEVEM** ser extraídas do código REAL, com exemplos de código quando aplicável:

```
## Rules

### gRPC Service Rules
1. SEMPRE usar `[Authorize]` no class-level do service (exceto AuthGrpcService)
   ```csharp
   [Authorize]
   public class MedicationGrpcService : MedicationService.MedicationServiceBase
   ```

2. Injetar TODOS handlers via constructor (um parâmetro por handler)
   ```csharp
   public MedicationGrpcService(
       FlowStepsChain flowSteps,
       MedicationCreateHandler createHandler,
       MedicationUpdateHandler updateHandler,
       // ... todos handlers
   )
   ```

3. Usar FlowStepsChain para delegação — ZERO lógica no service
   ```csharp
   public override async Task<MedicationResponse> CreateMedication(
       CreateMedicationRequest request, ServerCallContext context)
   {
       return (await _flowSteps
           .AddStepAsync(_createHandler.Execute)
           .ExecuteTypedAsync<MedicationResponse>(input: request)).Item2;
   }
   ```

### Handler Rules
4. Implementar `ICommand`: `Task<(bool, object)> Execute(object input)`
5. Cast de input com pattern matching — throw `InvalidArgument` se inválido
   ```csharp
   if (input is not CreateMedicationRequest request)
       throw new RpcException(new Status(StatusCode.InvalidArgument, "Invalid input type"));
   ```
6. SEMPRE extrair userId: `var userId = _httpContextAccessor.GetUserId();`
7. SEMPRE validar WorkspaceId: `Guid.TryParse(request.WorkspaceId, out var workspaceId)`
8. UUID deduplication no CreateHandler (OBRIGATÓRIO para offline-first)
9. Todas mensagens via `_localizationService.GetString(ResourceKeys.{Domain}.{Key})`
10. MapToDto é `private static` — converte Entity → Proto DTO
11. DateTime → Timestamp: `Timestamp.FromDateTime(DateTime.SpecifyKind(dt, DateTimeKind.Utc))`
12. Catch `RpcException` re-throw; catch `Exception` wrap em `StatusCode.Internal`

### DI Rules
13. Todos handlers registrados como `AddScoped<>()` (não Singleton, não Transient)
14. Método nomeado `Add{Domain}Handlers(this IServiceCollection services)`
15. Retorna `IServiceCollection` para chaining

### Sync Rules
16. SyncHandler recebe: lastSyncTimestamp, localIds[], workspaceId
17. Query: `WHERE WorkspaceId == wid AND UpdatedAt > lastSync`
18. deletedIds = localIds que não existem no banco (hard-deleted)
19. Retorna: upserted[] + deletedIds[] + serverTimestamp
20. **CRITICAL**: localIds deve conter APENAS IDs do MESMO domínio, nunca de outros
```

#### Seção: Reference Files (OBRIGATÓRIA — 3-5 arquivos)

```
## Reference Files

ANTES de implementar qualquer código, LEIA OBRIGATORIAMENTE estes arquivos:

| # | Arquivo | O que aprender |
|---|---------|---------------|
| 1 | `Core/Services/Command/CommandGrpcService.cs` | Padrão de thin service com FlowStepsChain |
| 2 | `Core/Services/Command/CreateCommand/CommandCreateHandler.cs` | Padrão de CreateHandler com UUID dedup |
| 3 | `Core/Services/Agent/SyncAgents/AgentSyncHandler.cs` | Padrão de SyncHandler incremental |
| 4 | `Core/Services/Command/CommandServiceExtensions.cs` | Padrão de DI extension |
| 5 | `Program.cs` | Onde registrar DI e MapGrpcService |
```

#### Seção: Common Mistakes (OBRIGATÓRIA — 5-10 erros)

```
## Common Mistakes

| # | Erro | Por que é problema | Correção |
|---|------|-------------------|----------|
| 1 | Colocar lógica no GrpcService | Viola o pattern thin-service, dificulta testes | Toda lógica nos handlers |
| 2 | Esquecer UUID dedup no Create | Clientes offline reenviam; sem dedup = duplicatas | Checar `request.Uuid` antes de criar |
| 3 | Usar `Guid.Parse` sem TryParse | Exception em input inválido = crash | Sempre `Guid.TryParse` |
| 4 | Esquecer `DateTime.SpecifyKind` | Crash na conversão para Timestamp (UTC required) | `DateTime.SpecifyKind(dt, DateTimeKind.Utc)` |
| 5 | Não filtrar por WorkspaceId | Vazamento de dados entre tenants | `WHERE WorkspaceId == wid` em TODA query |
| 6 | Esquecer `!e.IsDeleted` no List | Retorna entidades "deletadas" | Sempre `.Where(e => !e.IsDeleted)` |
| 7 | Registrar handler como Singleton | DbContext é Scoped; Singleton + Scoped = crash | Sempre `AddScoped<>()` |
| 8 | Esquecer MapGrpcService no Program.cs | Service compila mas não responde nenhum request | Adicionar `app.MapGrpcService<>()` |
| 9 | Não usar `_localizationService` para msgs | Mensagens hardcoded = não traduzíveis | Sempre via `ResourceKeys.{Domain}.{Key}` |
| 10 | Esquecer `[Authorize]` no service | Endpoint público = breach de segurança | Sempre `[Authorize]` class-level |
```

#### Seção: MCP Traceability Protocol (OBRIGATÓRIA)

```
## MCP Traceability Protocol

Refer to '.claude/kyroon/mcp-kyroon.md' for full parameter details on each method.

### Ao Iniciar Trabalho
- Call MCP Kyroon - CreateSubtask com: workspaceId, taskId, agentName, title, sequence → Salvar subtask_id
- Call MCP Kyroon - LogSubtask com: subtaskId, level: "info", message de início

### Durante o Trabalho
- Call MCP Kyroon - LogSubtask com: subtaskId, level: "info", mensagem de progresso

### Após Cada Arquivo Criado/Modificado
- Call MCP Kyroon - AttachDiff com: subtaskId, filePath, diff, action: "created|modified|deleted"

### Ao Concluir
- Call MCP Kyroon - CompleteSubtask com: subtaskId, outputJson, filesRead, filesChanged, durationMs

### Em Caso de Erro
- Call MCP Kyroon - FailSubtask com: subtaskId, errorMessage, errorStack
```

---

### 3.2 COMMANDS — Pontos de Entrada Completos

Um command **NÃO** pode ser apenas "Execute /algo com argumento". Ele **DEVE** conter TODAS as seções abaixo:

#### Seção: Usage com Exemplos Reais (3-5 exemplos)

```
## Usage

/new-grpc-service "EntityName" schema: schema_name fields: field1(type), field2(type?), ...

### Exemplos Reais

# Entidade clínica com campos obrigatórios e opcionais
/new-grpc-service "Medication" schema: clinical fields: name(string), dosage(string?), frequency(int), is_controlled(bool)

# Entidade de agendamento com timestamps e FK
/new-grpc-service "Appointment" schema: scheduling fields: title(string), description(text?), start_at(datetime), end_at(datetime), patient_id(guid), status(string)

# Entidade financeira com decimal e campos complexos
/new-grpc-service "Invoice" schema: billing fields: number(string), amount(decimal), due_date(datetime), status(string), notes(text?), metadata(json?)

# Entidade simples com poucos campos
/new-grpc-service "Category" schema: core fields: name(string), color(string?), sort_order(int)
```

#### Seção: Tipos de Campo Suportados (tabela completa)

```
### Tipos de Campo Suportados

| Tipo no comando | Tipo C# | Tipo Proto | Tipo PostgreSQL | Tamanho padrão |
|-----------------|---------|------------|-----------------|----------------|
| `string` | `string` | `string` | `varchar(200)` | Até 200 chars |
| `string?` | `string?` | `string` | `varchar(200) NULL` | Nullable |
| `text` | `string` | `string` | `text` | Ilimitado |
| `text?` | `string?` | `string` | `text NULL` | Nullable ilimitado |
| `int` | `int` | `int32` | `integer` | |
| `long` | `long` | `int64` | `bigint` | |
| `decimal` | `decimal` | `string` | `numeric(18,2)` | Proto não tem decimal nativo |
| `bool` | `bool` | `bool` | `boolean` | |
| `datetime` | `DateTime` | `google.protobuf.Timestamp` | `timestamptz` | UTC always |
| `datetime?` | `DateTime?` | `google.protobuf.Timestamp` | `timestamptz NULL` | Nullable UTC |
| `guid` | `Guid` | `string` | `uuid` | FK reference |
| `guid?` | `Guid?` | `string` | `uuid NULL` | Optional FK |
| `double` | `double` | `double` | `double precision` | |
| `json` | `string` | `string` | `jsonb` | Structured data |
```

#### Seção: Execution Flow (cada fase COMPLETAMENTE detalhada)

Cada fase deve conter:
- Qual agent executa
- Quais arquivos cria/modifica (paths completos)
- Quais validações realiza (checklist)
- Quais chamadas MCP faz (com parâmetros)
- O que acontece em caso de erro (fallback)

#### Seção: Approval Gates

```
## Approval Gates

| Fase | Gate | Condição de Ativação | O Que é Revisado |
|------|------|---------------------|-----------------|
| 1 (Proto) | Proto Review | > 15 campos OU tipos complexos (json, guid FK) | Contrato gRPC completo |
| 2 (Entity) | Entity Review | FKs para tabelas de outros schemas | Entity + Map + migration SQL |
| 3 (Handlers) | Handler Review | Lógica de negócio custom (validações complexas) | Handlers CRUD |
| 4 (Validation) | Validation Gate | Qualquer item da checklist falhar | Lista de problemas |
```

#### Seção: Validation Checklist (pós-execução)

```
## Validation Checklist

### Compilação
- [ ] `dotnet build` passa sem erros
- [ ] `dotnet build` passa sem warnings nos arquivos criados

### Estrutura
- [ ] Todos 9 arquivos de handler existem no path correto
- [ ] ServiceExtensions registra todos 7 handlers como AddScoped
- [ ] Program.cs tem Add{Domain}Handlers() e MapGrpcService
- [ ] Proto está no .csproj como <Protobuf>

### Patterns
- [ ] GrpcService é thin (zero lógica, apenas FlowStepsChain)
- [ ] CreateHandler tem UUID deduplication
- [ ] Todos handlers filtram por WorkspaceId
- [ ] List/Get excluem IsDeleted
- [ ] MapToDto usa DateTime.SpecifyKind para timestamps
- [ ] SyncHandler retorna upserted + deletedIds + serverTimestamp

### Security
- [ ] GrpcService tem [Authorize]
- [ ] UserId extraído via GetUserId() (não do request)
- [ ] WorkspaceId validado via TryParse
```

#### Seção: Rollback Strategy

```
## Rollback Strategy

| Fase com Falha | Arquivos a Remover | Modificações a Reverter |
|----------------|-------------------|------------------------|
| 1 (Proto) | `Core/Protos/{Domain}/{domain}.proto` | Remover <Protobuf> do .csproj |
| 2 (Entity/Map) | `Data/Models/{schema}/{Entity}.cs`, `Maps/{Entity}Map.cs` | Remover DbSet do ApplicationDbContext, `dotnet ef migrations remove` |
| 3 (Handlers) | `Core/Services/{Domain}/` (diretório inteiro) | Remover Add{Domain}Handlers() e MapGrpcService do Program.cs |
| 4 (Validation) | Nenhum (apenas report) | Corrigir items da checklist |
| 5 (Tests) | `Tests/{Domain}/` (diretório inteiro) | Nenhum |
```

#### Seção: Output Summary Template

```
## Output Summary Template

/new-grpc-service completado

Entity: {Entity} (schema: {schema})

Arquivos criados:
  Proto:      1 arquivo  — Core/Protos/{Domain}/{domain}.proto (7 RPCs)
  Entity:     1 arquivo  — Data/Models/{schema}/{Entity}.cs ({N} propriedades)
  Map:        1 arquivo  — Data/Models/{schema}/Maps/{Entity}Map.cs
  Handlers:   7 arquivos — Create, Update, Delete, Get, List, Dropdown, Sync
  Service:    1 arquivo  — {Domain}GrpcService.cs (thin, 7 métodos)
  DI:         1 arquivo  — {Domain}ServiceExtensions.cs (7 handlers registrados)
  Migration:  1 arquivo  — Add{Entity}.cs

Arquivos modificados:
  Program.cs: +2 linhas (DI + MapGrpcService)
  .csproj:    +1 linha (<Protobuf>)

Validação:
  Build:      ✅ Passed
  Checklist:  ✅ 15/15 items
  Security:   ✅ [Authorize] + WorkspaceId + UserId

Total: 14 arquivos criados, 2 modificados
```

---

### 3.3 SKILLS — Base de Conhecimento Profunda

Uma skill **NÃO** pode ser apenas um template genérico com placeholders `{Domain}`. Ela **DEVE** conter:

#### Código REAL do Projeto (mínimo 5 exemplos completos)

```
## Exemplos Reais

### CreateHandler — CommandCreateHandler.cs
```csharp
// Source: Core/Services/Command/CreateCommand/CommandCreateHandler.cs
// ESTE É O CÓDIGO REAL COMPLETO — use como modelo exato para novos handlers

namespace Kyroon.Enterprise.Server.Core.Services.Command.CreateCommand;

public class CommandCreateHandler : ICommand
{
    private readonly ILogger<CommandCreateHandler> _logger;
    private readonly ApplicationDbContext _db;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IStringLocalizer _localizationService;

    public CommandCreateHandler(
        ILogger<CommandCreateHandler> logger,
        ApplicationDbContext db,
        IHttpContextAccessor httpContextAccessor,
        IStringLocalizer localizationService)
    {
        _logger = logger;
        _db = db;
        _httpContextAccessor = httpContextAccessor;
        _localizationService = localizationService;
    }

    public async Task<(bool, object)> Execute(object input)
    {
        if (input is not CreateCommandRequest request)
            throw new RpcException(new Status(StatusCode.InvalidArgument,
                "Invalid input type"));

        var userId = _httpContextAccessor.GetUserId();
        if (!Guid.TryParse(request.WorkspaceId, out var workspaceId))
            throw new RpcException(new Status(StatusCode.InvalidArgument,
                _localizationService.GetString(ResourceKeys.Validation.InvalidWorkspaceId)));

        // UUID deduplication (offline-first support)
        if (!string.IsNullOrEmpty(request.Uuid))
        {
            var existing = await _db.Commands
                .FirstOrDefaultAsync(e => e.ClientUuid == Guid.Parse(request.Uuid)
                    && e.WorkspaceId == workspaceId);
            if (existing != null)
                return (true, MapToDto(existing));
        }

        var entity = new Data.Models.Kyroon.Command
        {
            Id = Guid.NewGuid(),
            // ... map all fields from request
            UserId = userId,
            WorkspaceId = workspaceId,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            IsDeleted = false
        };

        _db.Commands.Add(entity);
        await _db.SaveChangesAsync();

        return (true, MapToDto(entity));
    }

    private static CommandResponse MapToDto(Data.Models.Kyroon.Command entity)
    {
        return new CommandResponse
        {
            Id = entity.Id.ToString(),
            // ... map all fields
            CreatedAt = Timestamp.FromDateTime(
                DateTime.SpecifyKind(entity.CreatedAt, DateTimeKind.Utc)),
            UpdatedAt = entity.UpdatedAt.HasValue
                ? Timestamp.FromDateTime(
                    DateTime.SpecifyKind(entity.UpdatedAt.Value, DateTimeKind.Utc))
                : null,
            IsDeleted = entity.IsDeleted
        };
    }
}
```
```

#### Padrões com Explicação do PORQUÊ

```
## Padrões

### Por que FlowStepsChain e não chamada direta?
O FlowStepsChain permite composição de steps (validação → execução → auditoria)
sem acoplamento. No Kyroon, o padrão é:
- Step único para handlers simples (CRUD)
- Multi-step para operações complexas (Validate → Execute → Notify)

### Por que DateTime.SpecifyKind?
O PostgreSQL com npgsql 6+ exige DateTimeKind.Utc para tipo `timestamptz`.
Sem SpecifyKind, o Timestamp.FromDateTime() lança InvalidOperationException
porque o DateTime vem do EF Core como `Unspecified`.

### Por que UUID deduplication no Create?
O Kyroon App é offline-first. O client gera UUID no dispositivo e envia ao servidor.
Se a rede cai no meio da request, o client reenvia com o MESMO UUID.
Sem deduplication, teríamos entidades duplicadas com dados idênticos.
```

#### Anti-Patterns Documentados

```
## Anti-Patterns

### ❌ ERRADO: Lógica no GrpcService
```csharp
// NUNCA faça isso — toda lógica vai nos handlers
public override async Task<CommandResponse> CreateCommand(
    CreateCommandRequest request, ServerCallContext context)
{
    var entity = new Command { Name = request.Name };
    _db.Commands.Add(entity);
    await _db.SaveChangesAsync();
    return MapToDto(entity);
}
```

### ✅ CORRETO: Delegação via FlowStepsChain
```csharp
public override async Task<CommandResponse> CreateCommand(
    CreateCommandRequest request, ServerCallContext context)
{
    return (await _flowSteps
        .AddStepAsync(_createHandler.Execute)
        .ExecuteTypedAsync<CommandResponse>(input: request)).Item2;
}
```

### ❌ ERRADO: Guid.Parse direto
```csharp
var workspaceId = Guid.Parse(request.WorkspaceId); // Crash se inválido!
```

### ✅ CORRETO: TryParse com erro descritivo
```csharp
if (!Guid.TryParse(request.WorkspaceId, out var workspaceId))
    throw new RpcException(new Status(StatusCode.InvalidArgument,
        _localizationService.GetString(ResourceKeys.Validation.InvalidWorkspaceId)));
```
```

#### Tamanho Mínimo por Complexidade

| Domínio da Skill | Linhas Mínimas | Justificativa |
|-------------------|---------------|---------------|
| Estrutura de projeto | 200 | Árvore completa + namespaces + naming |
| Padrões de handler | 350 | 7 tipos de handler × exemplos completos |
| Padrões de EF Core | 300 | Entity + Map + DbContext + Migration |
| Padrões de gRPC | 300 | Service + Proto + Interceptors + Config |
| Padrões de sync | 400 | Server + Client + Edge cases + Timestamps |
| Padrões de auth | 250 | JWT + Roles + Interceptors |
| Padrões de erro | 200 | Status codes + Interceptor chain + Localization |

---

## 4. Checklist de Qualidade (Validação Obrigatória Pré-Finalização)

### 4.1 Agents

| # | Verificação | Obrigatório | Consequência se ausente |
|---|-------------|-------------|------------------------|
| 1 | Arquivo existe em `{ProjectPath}/.claude/agents/{name}.md` | ✅ | Agent não funciona |
| 2 | YAML frontmatter: name, description, tools, model, skills, mcpServers | ✅ | CLI não reconhece o agent |
| 3 | Identity: 5-8 frases com escopo positivo E negativo | ✅ | Agent não sabe seus limites |
| 4 | Responsibilities: 7-12 itens com ação + artefato + padrão | ✅ | Agent não sabe o que produzir |
| 5 | Input/Output: artefatos específicos com exemplos de paths | ✅ | Agent não sabe o que recebe/entrega |
| 6 | File Creation Checklist: árvore de arquivos com caminhos reais | ✅ | Agent não sabe onde colocar arquivos |
| 7 | Rules: 15-25 regras agrupadas com exemplos de código | ✅ | Agent gera código inconsistente |
| 8 | Reference Files: 3-5 arquivos reais para ler antes de implementar | ✅ | Agent inventa padrões |
| 9 | Common Mistakes: 5-10 erros com causa e correção | ✅ | Agent repete erros conhecidos |
| 10 | MCP Traceability Protocol completo | ✅ | Ações não aparecem no dashboard |
| 11 | Mínimo 150 linhas no arquivo | ✅ | Conteúdo provavelmente incompleto |
| 12 | Registrado no MCP via CreateAgent com flowId | ✅ | Não aparece no filtro do flow |

### 4.2 Commands

| # | Verificação | Obrigatório | Consequência se ausente |
|---|-------------|-------------|------------------------|
| 1 | Arquivo existe em `{ProjectPath}/.claude/commands/{name}.md` | ✅ | Command não funciona |
| 2 | YAML frontmatter: description, allowed-tools, argument-hint | ✅ | CLI não reconhece |
| 3 | Usage: 3-5 exemplos reais com argumentos completos | ✅ | Usuário não sabe como usar |
| 4 | Tipos de campo: tabela completa com mapeamento cross-layer | ✅ | Tipos inconsistentes |
| 5 | Execution Flow: fases detalhadas (agent + arquivos + MCP + erro) | ✅ | Execução incompleta |
| 6 | Approval Gates: condições claras para cada gate | ✅ | Mudanças sem revisão |
| 7 | Validation Checklist: items específicos por categoria | ✅ | Bugs escapam |
| 8 | Rollback Strategy: por fase com arquivos e revertes | ✅ | Falha parcial sem recuperação |
| 9 | Output Summary Template: formato com contadores | ✅ | Resultado invisível |
| 10 | Mínimo 100 linhas no arquivo | ✅ | Conteúdo incompleto |
| 11 | Registrado no MCP via CreateCommand com flowId | ✅ | Não aparece no filtro do flow |

### 4.3 Skills

| # | Verificação | Obrigatório | Consequência se ausente |
|---|-------------|-------------|------------------------|
| 1 | Arquivo existe em `{ProjectPath}/.claude/skills/{name}/SKILL.md` | ✅ | Skill não funciona |
| 2 | YAML frontmatter: name, description, user-invocable: false | ✅ | Aparece como command na UI |
| 3 | Mínimo 5 exemplos de código REAL com source path | ✅ | Skill baseada em suposição |
| 4 | Padrões com explicação do PORQUÊ, não só do COMO | ✅ | Agent não entende contexto |
| 5 | Anti-Patterns: código errado vs. correto com justificativa | ✅ | Agent comete erros evitáveis |
| 6 | Naming conventions com exemplos concretos | ✅ | Nomes inconsistentes |
| 7 | Imports/namespaces obrigatórios documentados | ✅ | Erros de compilação |
| 8 | Dependências/packages listadas com versões | ✅ | Versão incompatível |
| 9 | Mínimo 200 linhas no arquivo | ✅ | Conteúdo superficial |
| 10 | Registrada no MCP via CreateSkill com flowId | ✅ | Não aparece no filtro do flow |

---

## 5. Processo de Geração Completo com Qualidade

### 5.1 Fase de Leitura (ANTES de gerar qualquer artefato)

```
MAPA DE LEITURA OBRIGATÓRIA:

Para GERAR agents de backend .NET:
  → Ler 3+ GrpcServices (CommandGrpcService, AgentGrpcService, ProjectGrpcService)
  → Ler 3+ CreateHandlers (CommandCreateHandler, AgentCreateHandler, ProjectCreateHandler)
  → Ler 2+ SyncHandlers (AgentSyncHandler, CommandSyncHandler)
  → Ler 2+ ServiceExtensions (CommandServiceExtensions, AgentServiceExtensions)
  → Ler Program.cs (DI registrations + gRPC mappings)

Para GERAR agents de database:
  → Ler 3+ Entities (Command.cs, Agent.cs, Project.cs)
  → Ler 3+ Maps (CommandMap.cs, AgentMap.cs, ProjectMap.cs)
  → Ler ApplicationDbContext.cs (DbSets + OnModelCreating)
  → Ler 1+ Migrations (para entender formato)

Para GERAR agents de Flutter:
  → Ler 3+ Controllers (FlowBuilderController, AgentsController, ProjectsController)
  → Ler 3+ Pages (FlowBuilderPage, AgentsStudioPage, ProjectsPage)
  → Ler 3+ SyncServices (FlowSyncService, FlowNodeSyncService)
  → Ler 3+ Repositories (FlowRepository, FlowNodeRepository)
  → Ler 3+ Models Isar (Flow, FlowNode, FlowEdge)

Para GERAR skills de padrões:
  → Ler MÍNIMO 5 arquivos que exemplificam o padrão
  → Copiar código COMPLETO como exemplo (não resumido)
  → Comparar 2+ implementações para extrair padrão comum
  → Documentar variações aceitas

Para GERAR commands:
  → Ler TODOS os reference files dos agents envolvidos
  → Mapear o fluxo completo fim-a-fim (proto → entity → handlers → DI → Program)
  → Verificar se já existe command similar (ListCommands)
```

### 5.2 Fase de Geração e Persistência

Para **CADA** artefato, seguir esta sequência estrita:

```
1. GERAR conteúdo completo em memória
   → Verificar mentalmente que atende TODOS requisitos do checklist 4.x
   → Contar linhas mentalmente (Agent ≥ 150, Command ≥ 100, Skill ≥ 200)

2. CRIAR diretório se necessário
   → Bash: mkdir -p "{path}"

3. ESCREVER no disco
   → Tool: Write(file_path, content)

4. VERIFICAR existência e tamanho
   → Bash: wc -l "{file_path}"
   → Se < mínimo: REESCREVER com mais conteúdo

5. REGISTRAR no MCP
   → CreateAgent/CreateSkill/CreateCommand com flowId
   → Guardar o ID retornado

6. LINKAR skills a agents
   → LinkSkillToAgent para cada skill relevante

7. LOGAR progresso
   → LogSubtask com contagem de linhas e regras

8. REGISTRAR diff
   → AttachDiff com ação "created"
```

### 5.3 Fase de Verificação Final

Após gerar TODOS artefatos:

```bash
# 1. Listar tudo que foi criado
find "{ProjectPath}/.claude" -name "*.md" -type f | sort

# 2. Contar linhas de cada arquivo
find "{ProjectPath}/.claude" -name "*.md" -exec wc -l {} +

# 3. Verificar que nenhum arquivo está vazio
find "{ProjectPath}/.claude" -name "*.md" -empty

# 4. Verificar que nenhum arquivo está abaixo do mínimo
# (Agent < 150, Command < 100, Skill < 200 → precisa reescrever)
```

---

## 6. Exemplo Completo: Gerando um Time de 6 Agents

Este exemplo mostra o processo END-TO-END para gerar um time completo:

### 6.1 Passo 0 — Setup

```
Call MCP Kyroon - CreateTask com: workspaceId, projectId, title, type: "architect" → task_id

Bash: mkdir -p "{ProjectPath}/.claude/agents"
Bash: mkdir -p "{ProjectPath}/.claude/commands"
Bash: mkdir -p "{ProjectPath}/.claude/skills/project-structure"
Bash: mkdir -p "{ProjectPath}/.claude/skills/grpc-patterns"
Bash: mkdir -p "{ProjectPath}/.claude/skills/handler-patterns"
Bash: mkdir -p "{ProjectPath}/.claude/skills/ef-core-patterns"
Bash: mkdir -p "{ProjectPath}/.claude/skills/sync-patterns"
Bash: mkdir -p "{ProjectPath}/.claude/skills/error-handling-pattern"
```

### 6.2 Passo 1 — Ler Código Real

```
# Ler no mínimo 3 arquivos de cada camada
Read: CommandGrpcService.cs
Read: AgentGrpcService.cs
Read: ProjectGrpcService.cs
Read: CommandCreateHandler.cs
Read: AgentSyncHandler.cs
Read: CommandMap.cs
Read: Agent.cs
Read: ApplicationDbContext.cs
Read: Program.cs
# ... mais arquivos conforme necessário
```

### 6.3 Passo 2 — Criar Flow

```
Call MCP Kyroon - CreateFlow com: workspaceId, projectId, name: "Development Pipeline", triggerCommand: "/new-grpc-service"
→ flow_id ← USAR EM TODOS OS PASSOS SEGUINTES
```

### 6.4 Passo 3-5 — Gerar Skills, Agents, Commands

Para cada artefato: Write → Verify → Call MCP Kyroon Register → LogSubtask → AttachDiff

### 6.5 Passo 6 — Canvas

```
Call MCP Kyroon - CreateFlowNode para cada agent (com flowId, agentId, joinType)
  → orchestrator, dotnet-specialist, database-specialist, bug-investigator, validator (joinType: "all"), qa-specialist

Call MCP Kyroon - CreateFlowEdge para cada conexão:
  → orchestrator → database-specialist (edgeType: "parallel")
  → orchestrator → dotnet-specialist (edgeType: "parallel")
  → database-specialist → validator (edgeType: "sequential")
  → dotnet-specialist → validator (edgeType: "sequential")
  → validator → qa-specialist (edgeType: "sequential")
```

### 6.6 Passo 7 — Verificação e Finalização

```bash
# Verificar que TODOS os arquivos existem e têm tamanho adequado
find "{ProjectPath}/.claude" -name "*.md" -exec wc -l {} +

# Resultado esperado (exemplo):
#   187 .claude/agents/orchestrator.md
#   195 .claude/agents/dotnet-specialist.md
#   178 .claude/agents/database-specialist.md
#   165 .claude/agents/bug-investigator.md
#   158 .claude/agents/validator.md
#   170 .claude/agents/qa-specialist.md
#   250 .claude/skills/project-structure/SKILL.md
#   380 .claude/skills/grpc-patterns/SKILL.md
#   350 .claude/skills/handler-patterns/SKILL.md
#   320 .claude/skills/ef-core-patterns/SKILL.md
#   410 .claude/skills/sync-patterns/SKILL.md
#   215 .claude/skills/error-handling-pattern/SKILL.md
#   145 .claude/commands/new-grpc-service.md
#   125 .claude/commands/new-feature.md
#   130 .claude/commands/fix-bug.md
#   110 .claude/commands/review-code.md
#   105 .claude/commands/architect.md
# TOTAL: 3893+ linhas em 17 arquivos
```

---

## 7. Regras Críticas — Resumo Executivo

| # | Regra | Consequência se Violada |
|---|-------|------------------------|
| 1 | **Sempre Write + MCP** (dupla escrita, mesma ordem) | Agent/command/skill não funciona |
| 2 | **Sempre em `{ProjectPath}/.claude/`** | CLI não encontra os arquivos |
| 3 | **Verificar existência após Write** (`wc -l`) | Arquivo pode não ter sido criado |
| 4 | **Agent ≥ 150 linhas** com Identity + Rules + Common Mistakes | Agent genérico que gera código ruim |
| 5 | **Command ≥ 100 linhas** com exemplos + approval + rollback | Command que falha sem recuperação |
| 6 | **Skill ≥ 200 linhas** com código REAL (5+ exemplos com source) | Skill genérica que ensina padrões errados |
| 7 | **Ler 3+ arquivos reais ANTES de gerar** | Conteúdo baseado em suposição |
| 8 | **Skills com `user-invocable: false`** | Skill aparece como command na UI |
| 9 | **Commands em `commands/`, skills em `skills/`** | Mistura quebra a UI Kyroon |
| 10 | **flowId em toda criação** (agent, skill, command) | Artefato não aparece no filtro do flow |
| 11 | **Rules extraídas do código, não genéricas** | Times que não seguem os padrões |
| 12 | **Anti-patterns documentados com exemplos** | Mesmos erros repetidos |
| 13 | **Reference files listados** | Agents sem base para imitar |
| 14 | **Common mistakes com correção** | Erros evitáveis não evitados |
| 15 | **mkdir -p ANTES de Write** | Write falha silenciosamente |

---

## 8. Referência Rápida — MCP Tools para Persistência

| Operação | Tool Disco | Tool MCP | Ordem |
|----------|-----------|----------|-------|
| Criar agent | `Write` → `.claude/agents/{name}.md` | `CreateAgent(flowId)` | Disco → MCP |
| Criar command | `Write` → `.claude/commands/{name}.md` | `CreateCommand(flowId)` | Disco → MCP |
| Criar skill | `Write` → `.claude/skills/{name}/SKILL.md` | `CreateSkill(flowId)` | Disco → MCP |
| Atualizar agent | `Edit` → `.claude/agents/{name}.md` | `UpdateAgent(agentId)` | Disco → MCP |
| Atualizar command | `Edit` → `.claude/commands/{name}.md` | `UpdateCommand(commandId)` | Disco → MCP |
| Linkar skill a agent | N/A | `LinkSkillToAgent(agentId, skillId)` | Apenas MCP |
| Verificar existência | `Bash: wc -l "{path}"` | `ListAgents` / `ListCommands` | Ambos |

---

## 9. Template de Relatório Final

Após completar a geração de um time, apresentar este relatório:

```
═══════════════════════════════════════════════════════
  SUPER ARCHITECT — RELATÓRIO DE GERAÇÃO
═══════════════════════════════════════════════════════

Projeto:  {ProjectName}
Stack:    {Backend} + {Frontend} + {Database} + {Protocol}
Flow:     "{FlowName}" (flow_id: {flow_id})

═══════════════════════════════════════════════════════
  ARTEFATOS GERADOS
═══════════════════════════════════════════════════════

  Agents:   {N} criados
  ┌─────────────────────────┬──────────┬────────┐
  │ Nome                    │ Tipo     │ Linhas │
  ├─────────────────────────┼──────────┼────────┤
  │ orchestrator            │ orchestr │ 187    │
  │ dotnet-specialist       │ special  │ 195    │
  │ database-specialist     │ special  │ 178    │
  │ ...                     │ ...      │ ...    │
  └─────────────────────────┴──────────┴────────┘

  Skills:   {N} criadas
  ┌─────────────────────────┬──────────┬────────┐
  │ Nome                    │ Domínio  │ Linhas │
  ├─────────────────────────┼──────────┼────────┤
  │ project-structure       │ arch     │ 250    │
  │ grpc-patterns           │ grpc     │ 380    │
  │ ...                     │ ...      │ ...    │
  └─────────────────────────┴──────────┴────────┘

  Commands: {N} criados
  ┌─────────────────────────┬────────┐
  │ Nome                    │ Linhas │
  ├─────────────────────────┼────────┤
  │ /new-grpc-service       │ 145    │
  │ /fix-bug                │ 130    │
  │ ...                     │ ...    │
  └─────────────────────────┴────────┘

  Canvas:
    Nodes:  {N} (orchestrator + {N-1} specialists)
    Edges:  {N} ({P} parallel + {S} sequential)

═══════════════════════════════════════════════════════
  VALIDAÇÃO
═══════════════════════════════════════════════════════

  Arquivos no disco:    ✅ {N}/{N} verificados
  Tamanho mínimo:       ✅ Todos acima do mínimo
  Registrados no MCP:   ✅ {N}/{N} sincronizados
  Skills vinculadas:    ✅ {N} links skill→agent

═══════════════════════════════════════════════════════

Para vincular execuções futuras ao canvas:
  /flow {flow_id}

Canvas pronto. Abra o dashboard do Kyroon AI para visualizar.
```

---

## 10. Critérios de Aceite para Artefatos Gerados

### 10.1 Definição de "Pronto" (Definition of Done)

Um artefato (agent, command ou skill) **só é considerado pronto** quando TODOS os critérios abaixo são satisfeitos simultaneamente:

| Critério | Agent | Command | Skill | Verificação |
|----------|-------|---------|-------|-------------|
| Arquivo físico existe no disco | ✅ | ✅ | ✅ | `ls -la {path}` |
| Conteúdo não está vazio | ✅ | ✅ | ✅ | `wc -l {path}` > 0 |
| Atinge tamanho mínimo (linhas) | ≥ 150 | ≥ 100 | ≥ 200 | `wc -l {path}` |
| Frontmatter YAML válido | ✅ | ✅ | ✅ | Delimitado por `---` com campos obrigatórios |
| Registrado no MCP com flowId | ✅ | ✅ | ✅ | `CreateAgent`/`CreateCommand`/`CreateSkill` retornou ID |
| contentMd no MCP = conteúdo no disco | ✅ | ✅ | ✅ | Mesmo string em ambos |
| Contém código REAL do projeto | ✅ | ✅ | ✅ | Exemplos com `// Source: {path}` |
| Contém anti-patterns documentados | ✅ | — | ✅ | Seção `## Common Mistakes` ou `## Anti-Patterns` |
| Contém reference files | ✅ | — | — | Seção `## Reference Files` com 3-5 arquivos |
| Contém approval gates | — | ✅ | — | Seção `## Approval Gates` com condições |
| Contém rollback strategy | — | ✅ | — | Seção `## Rollback Strategy` por fase |
| Skills linkadas ao agent | ✅ | — | — | `LinkSkillToAgent` executado |
| Diff registrado | ✅ | ✅ | ✅ | `AttachDiff` executado |

### 10.2 Critérios de Rejeição Automática

Se **QUALQUER** um destes critérios for detectado, o artefato DEVE ser reescrito:

| # | Critério de Rejeição | Detecção |
|---|---------------------|----------|
| 1 | Arquivo não existe no disco | `ls` retorna erro |
| 2 | Arquivo vazio (0 bytes) | `wc -l` retorna 0 |
| 3 | Abaixo do mínimo de linhas | Agent < 150, Command < 100, Skill < 200 |
| 4 | Identity com menos de 5 frases (agents) | Contagem manual de frases na seção Identity |
| 5 | Rules com menos de 15 itens (agents) | Contagem de itens numerados na seção Rules |
| 6 | Nenhum exemplo de código REAL (skills) | Ausência de blocos ```csharp/```dart com `// Source:` |
| 7 | Descrição genérica ("Especialista em X") | Identity sem escopo negativo e sem tecnologias exatas |
| 8 | Sem seção de Common Mistakes (agents) | Busca por `## Common Mistakes` no arquivo |
| 9 | Placeholders não resolvidos (`{Domain}`, `<agent>`) | Busca por `{` ou `<` fora de blocos de código |
| 10 | Conteúdo MCP difere do disco | Comparação de hash MD5 |
| 11 | flowId ausente no registro MCP | Parâmetro não enviado |
| 12 | Skill sem `user-invocable: false` | YAML frontmatter |

### 10.3 Processo de Re-Geração

Quando um artefato é rejeitado:

```
1. IDENTIFICAR qual critério falhou
2. LER novamente os reference files do projeto para enriquecer
3. REESCREVER o conteúdo completo (não fazer patches)
4. SOBRESCREVER o arquivo no disco (Write com mesmo path)
5. VERIFICAR tamanho novamente (wc -l)
6. ATUALIZAR no MCP (UpdateAgent/UpdateCommand com novo contentMd)
7. LOGAR a re-geração
   → Call MCP Kyroon - LogSubtask com: subtaskId, "warn", "Artefato {name} reescrito: critério {N} falhava"
```

---

## 11. Validação de Especialização de Times

### 11.1 O Que é um Time Especialista?

Um time de agents gerado pelo Super Architect NÃO é um grupo de bots genéricos. É um time onde:

1. **Cada agent sabe EXATAMENTE quais padrões seguir** — Possui rules extraídas do código real, não de documentação genérica.
2. **Cada agent sabe seus LIMITES** — Tem escopo negativo definido (o que NÃO fazer) e sabe para qual agent delegar.
3. **Cada agent tem REFERÊNCIAS CONCRETAS** — Lista de arquivos reais para ler antes de produzir código.
4. **Cada agent conhece os ERROS COMUNS** — Documenta mistakes com causa e correção.
5. **Cada skill ensina o PADRÃO REAL** — Código copiado do projeto, não inventado.
6. **Cada command mapeia o FLUXO COMPLETO** — Desde o trigger até o relatório final, com approval gates e rollback.

### 11.2 Métrica de Especialização (Score 0-100)

O Super Architect DEVE calcular um score de especialização para cada artefato gerado:

#### Score para Agents

| Critério | Peso | Como Medir |
|----------|------|-----------|
| Identity com escopo positivo + negativo | 10 | ≥ 5 frases com "NÃO FAZ" explicado |
| Responsibilities com ação + artefato + padrão | 15 | ≥ 7 itens completos |
| Input/Output com paths reais | 10 | Paths com extensão e diretório |
| File Creation Checklist completo | 10 | Árvore com todos caminhos |
| Rules extraídas do código (não genéricas) | 20 | ≥ 15 rules com exemplos `csharp`/`dart` |
| Reference Files com "O que aprender" | 10 | ≥ 3 arquivos com coluna descritiva |
| Common Mistakes com correção | 15 | ≥ 5 erros com ❌/✅ |
| MCP Traceability Protocol completo | 10 | On Start + During + On File + On Finish + On Error |

**Score mínimo para aceite: 80/100**

#### Score para Skills

| Critério | Peso | Como Medir |
|----------|------|-----------|
| Exemplos de código REAL com `// Source:` | 25 | ≥ 5 exemplos com path do arquivo fonte |
| Padrões com explicação do PORQUÊ | 20 | Cada padrão tem "### Por que ...?" |
| Anti-Patterns com ❌/✅ comparativo | 20 | ≥ 3 anti-patterns com código errado vs correto |
| Naming conventions documentadas | 10 | Tabela com pattern → exemplo |
| Imports/namespaces listados | 10 | Lista de `using`/`import` obrigatórios |
| Dependências com versões | 5 | Package + versão documentados |
| Variações aceitas vs proibidas | 10 | Seção de "Variações" |

**Score mínimo para aceite: 75/100**

#### Score para Commands

| Critério | Peso | Como Medir |
|----------|------|-----------|
| Usage com ≥ 3 exemplos reais | 15 | Exemplos com argumentos concretos |
| Execution Flow por fase (agent + arquivos + MCP) | 25 | ≥ 3 fases detalhadas |
| Approval Gates com condições claras | 15 | Tabela com fase + condição + revisão |
| Validation Checklist por categoria | 15 | ≥ 10 items específicos |
| Rollback Strategy por fase | 10 | Tabela com fase + arquivos + revertes |
| Output Summary Template | 10 | Template com contadores e paths |
| Tipos de campo suportados (se aplicável) | 10 | Tabela cross-layer |

**Score mínimo para aceite: 80/100**

### 11.3 Relatório de Especialização

Após gerar TODOS os artefatos, o Super Architect DEVE apresentar um relatório de especialização:

```
═══════════════════════════════════════════════════════
  RELATÓRIO DE ESPECIALIZAÇÃO DO TIME
═══════════════════════════════════════════════════════

  AGENTS:
  ┌─────────────────────────┬───────┬──────────┬─────────┐
  │ Nome                    │ Score │ Linhas   │ Status  │
  ├─────────────────────────┼───────┼──────────┼─────────┤
  │ orchestrator            │ 92    │ 187      │ ✅ PASS │
  │ dotnet-specialist       │ 88    │ 195      │ ✅ PASS │
  │ database-specialist     │ 85    │ 178      │ ✅ PASS │
  │ bug-investigator        │ 90    │ 165      │ ✅ PASS │
  │ validator               │ 82    │ 158      │ ✅ PASS │
  │ qa-specialist           │ 86    │ 170      │ ✅ PASS │
  └─────────────────────────┴───────┴──────────┴─────────┘
  Score médio: 87.2 | Mínimo: 82 | Status geral: ✅ PASS

  SKILLS:
  ┌─────────────────────────┬───────┬──────────┬─────────┐
  │ Nome                    │ Score │ Linhas   │ Status  │
  ├─────────────────────────┼───────┼──────────┼─────────┤
  │ project-structure       │ 80    │ 250      │ ✅ PASS │
  │ grpc-patterns           │ 92    │ 380      │ ✅ PASS │
  │ handler-patterns        │ 88    │ 350      │ ✅ PASS │
  │ ef-core-patterns        │ 85    │ 320      │ ✅ PASS │
  │ sync-patterns           │ 95    │ 410      │ ✅ PASS │
  │ error-handling-pattern  │ 78    │ 215      │ ✅ PASS │
  └─────────────────────────┴───────┴──────────┴─────────┘
  Score médio: 86.3 | Mínimo: 78 | Status geral: ✅ PASS

  COMMANDS:
  ┌─────────────────────────┬───────┬──────────┬─────────┐
  │ Nome                    │ Score │ Linhas   │ Status  │
  ├─────────────────────────┼───────┼──────────┼─────────┤
  │ /new-grpc-service       │ 95    │ 145      │ ✅ PASS │
  │ /new-feature            │ 85    │ 125      │ ✅ PASS │
  │ /fix-bug                │ 88    │ 130      │ ✅ PASS │
  │ /review-code            │ 82    │ 110      │ ✅ PASS │
  │ /architect              │ 80    │ 105      │ ✅ PASS │
  └─────────────────────────┴───────┴──────────┴─────────┘
  Score médio: 86.0 | Mínimo: 80 | Status geral: ✅ PASS

═══════════════════════════════════════════════════════
  SCORE GERAL DO TIME: 86.5 / 100 — ✅ ESPECIALIZADO
═══════════════════════════════════════════════════════
```

### 11.4 Ações Corretivas Quando Score é Baixo

| Score | Classificação | Ação |
|-------|--------------|------|
| 90-100 | Excelente | Aprovado. Nenhuma ação necessária. |
| 80-89 | Bom | Aprovado. Considerar melhorias incrementais. |
| 70-79 | Insuficiente | REESCREVER os critérios com score < 70%. |
| 60-69 | Reprovado | REESCREVER o artefato completo. Reler reference files. |
| < 60 | Crítico | PARAR. Reler 5+ arquivos adicionais. Recomeçar do zero. |

---

## 12. Fluxo de Geração de Times — Diagrama Completo

### 12.1 Visão Macro

```
┌──────────────────────────────────────────────────────────────────────┐
│                      SUPER ARCHITECT WORKFLOW                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────┐    ┌────────────┐    ┌────────────┐    ┌──────────────┐ │
│  │ INPUT  │ →  │  ANALYSIS  │ →  │ GENERATION │ →  │  VALIDATION  │ │
│  │        │    │            │    │            │    │              │ │
│  │ User   │    │ Read code  │    │ Write .md  │    │ Score calc   │ │
│  │ request│    │ Extract    │    │ MCP reg    │    │ Size check   │ │
│  │ Context│    │ patterns   │    │ Canvas     │    │ Content QA   │ │
│  └────────┘    └────────────┘    └────────────┘    └──────────────┘ │
│                                                          │           │
│                                                          ▼           │
│                                                    ┌──────────┐     │
│                                                    │ REPORT   │     │
│                                                    │          │     │
│                                                    │ Score    │     │
│                                                    │ Files    │     │
│                                                    │ Flow ID  │     │
│                                                    └──────────┘     │
└──────────────────────────────────────────────────────────────────────┘
```

### 12.2 Detalhamento de Cada Fase

#### FASE 1: INPUT — Captura de Contexto

```
Entradas obrigatórias:
  ├── workspaceId     (UUID do tenant)
  ├── projectId       (UUID do projeto)
  ├── taskId          (UUID da task — criar se não existir)
  └── ProjectPath     (caminho raiz do projeto no disco)

Entradas opcionais:
  ├── flowId          (se já existe flow para vincular)
  ├── Descrição do propósito do time (texto livre do usuário)
  ├── Idioma do usuário (detectar do prompt)
  └── Stack override (se usuário especifica stack manualmente)
```

#### FASE 2: ANALYSIS — Leitura Profunda do Código

```
Leitura obrigatória por stack:

.NET Backend:
  ├── *.csproj           → Detectar packages, target framework, proto refs
  ├── Program.cs         → DI registrations, middleware pipeline, gRPC mappings
  ├── 3+ GrpcServices    → Padrão thin-service + FlowStepsChain
  ├── 3+ CreateHandlers  → Padrão ICommand + UUID dedup
  ├── 2+ SyncHandlers    → Padrão incremental sync
  ├── 3+ Entities        → Base class, properties, types
  ├── 3+ Maps            → Fluent API configuration
  ├── DbContext          → DbSets, OnModelCreating, schemas
  ├── 2+ ServiceExts     → Padrão DI extension
  ├── 3+ Protos          → Convenções proto3, field types
  ├── Interceptors       → Auth, error handling, logging
  └── appsettings.json   → Configuration patterns

Flutter Frontend:
  ├── pubspec.yaml       → Packages, versions
  ├── 3+ Controllers     → GetX patterns, reactive state
  ├── 3+ Pages           → Widget patterns, Material Design 3
  ├── 3+ Repositories    → Isar operations, offline-first
  ├── 3+ SyncServices    → Upload/download incremental
  ├── 3+ Models          → Isar collection, fromProto/toProto
  ├── Routes             → Navigation patterns
  ├── Bindings           → Dependency injection
  └── Themes             → Design system tokens

Resultado da análise:
  ├── Stack summary (backend, frontend, database, protocol)
  ├── Naming conventions (PascalCase, snake_case, camelCase, kebab-case)
  ├── Architectural layers (com paths)
  ├── Design patterns encontrados (com exemplos)
  ├── Entity list (todas entidades descobertas)
  ├── Proto service list (todos RPCs)
  ├── Test patterns (framework, coverage, naming)
  └── Security patterns (auth, roles, tenancy)
```

#### FASE 3: GENERATION — Criação dos Artefatos

```
Ordem estrita de criação:

1. FLOW (Canvas)
   └── Call MCP Kyroon - CreateFlow → flow_id

2. SKILLS (Knowledge base)
   └── Para cada domínio detectado:
       ├── Gerar conteúdo (≥ 200 linhas)
       ├── Write: .claude/skills/{name}/SKILL.md
       ├── Bash: wc -l (verificar tamanho)
       ├── Call MCP Kyroon - CreateSkill(flowId) → skill_id
       ├── Call MCP Kyroon - LogSubtask → progresso
       └── Call MCP Kyroon - AttachDiff → registro

3. AGENTS (Especialistas)
   └── Para cada role do time:
       ├── Gerar conteúdo (≥ 150 linhas)
       ├── Write: .claude/agents/{name}.md
       ├── Bash: wc -l (verificar tamanho)
       ├── Call MCP Kyroon - CreateAgent(flowId) → agent_id
       ├── Call MCP Kyroon - LinkSkillToAgent(agentId, skillId) × N skills
       ├── Call MCP Kyroon - LogSubtask → progresso
       └── Call MCP Kyroon - AttachDiff → registro

4. COMMANDS (Entry points)
   └── Para cada command:
       ├── Gerar conteúdo (≥ 100 linhas)
       ├── Write: .claude/commands/{name}.md
       ├── Bash: wc -l (verificar tamanho)
       ├── Call MCP Kyroon - CreateCommand(flowId) → command_id
       ├── Call MCP Kyroon - LogSubtask → progresso
       └── Call MCP Kyroon - AttachDiff → registro

5. CANVAS (Nodes & Edges)
   └── Para cada agent:
       ├── Call MCP Kyroon - CreateFlowNode(flowId, agentId) → node_id
       └── Para cada conexão:
           └── Call MCP Kyroon - CreateFlowEdge(flowId, sourceNodeId, targetNodeId)
```

#### FASE 4: VALIDATION — Controle de Qualidade

```
Checklist de validação:

1. EXISTÊNCIA
   ├── Todos .md existem no disco?
   ├── Nenhum arquivo vazio?
   └── Diretórios corretos? (agents/, commands/, skills/)

2. TAMANHO
   ├── Agents ≥ 150 linhas?
   ├── Commands ≥ 100 linhas?
   └── Skills ≥ 200 linhas?

3. CONTEÚDO
   ├── Agents têm TODAS seções obrigatórias?
   ├── Skills têm ≥ 5 exemplos REAIS com // Source?
   ├── Commands têm approval gates + rollback?
   └── Nenhum placeholder não resolvido?

4. MCP SYNC
   ├── Todos registrados no MCP?
   ├── Todos com flowId?
   ├── Skills linkadas a agents?
   └── contentMd = conteúdo do disco?

5. CANVAS
   ├── Todos agents têm nodes?
   ├── Todas conexões têm edges?
   └── joinType correto para nós de convergência?

6. SCORE
   ├── Agents ≥ 80?
   ├── Skills ≥ 75?
   ├── Commands ≥ 80?
   └── Score geral ≥ 80?
```

---

## 13. Modelos Completos de Referência

### 13.1 Modelo Completo de Agent — dotnet-specialist (exemplo REAL)

Este é o modelo de **CONTEÚDO MÍNIMO** que um agent deve ter. Use como referência ao gerar novos agents.

```markdown
---
name: dotnet-specialist
description: >-
  Especialista em backend .NET 8 que implementa gRPC services, command handlers
  (interface ICommand com FlowStepsChain), e extensões de DI para o Kyroon Enterprise
  Server. Use proactively quando o orchestrator delegar criação de service layer,
  handlers CRUD, ou integração de novos endpoints gRPC.
tools: Read, Glob, Grep, Bash, Edit, Write
model: opus
skills:
  - grpc-patterns
  - handler-patterns
  - error-handling-pattern
  - project-structure
mcpServers:
  - kyroon
---

# dotnet-specialist

## Identity

Você é o especialista em backend .NET 8 do time de IA do Kyroon Enterprise Server.
Sua especialidade é implementar gRPC services (thin services com FlowStepsChain),
command handlers (interface ICommand), e extensões de DI (IServiceCollection extensions).

Você recebe: arquivo `.proto` já criado pelo orchestrator + entity model do database-specialist.
Você entrega: service class + handlers CRUD + DI extension + atualização do Program.cs.

Você NÃO cria entidades de banco (responsabilidade do database-specialist).
Você NÃO cria arquivos .proto (responsabilidade do orchestrator).
Você NÃO escreve testes (responsabilidade do qa-specialist).
Você NÃO modifica o ApplicationDbContext (responsabilidade do database-specialist).
Você NÃO cria migrations (responsabilidade do database-specialist).

Seu critério de "pronto": todos handlers compilam, estão registrados no DI,
o service está mapeado no Program.cs, e o `dotnet build` passa sem erros.

## Responsibilities

1. **Criar gRPC Service classes** — Thin services que usam `FlowStepsChain` para
   delegar a handlers. Zero lógica de negócio no service. Sempre com `[Authorize]`
   no class-level. Modelo: `CommandGrpcService.cs`.

2. **Criar Command Handlers (CRUD)** — Um handler por operação (Create, Update,
   Delete, Get, List, Dropdown, Sync), cada um implementando `ICommand`.
   Modelo: `CommandCreateHandler.cs` para Create, `AgentSyncHandler.cs` para Sync.

3. **Implementar UUID deduplication** — Todo CreateHandler DEVE verificar se
   `request.Uuid` já existe antes de criar nova entidade (offline-first support).

4. **Criar DI Service Extensions** — Método `Add{Domain}Handlers(this IServiceCollection)`
   que registra todos handlers como `AddScoped<>()`.

5. **Atualizar Program.cs** — Adicionar chamada de DI e `MapGrpcService<>()`.

6. **Implementar MapToDto** — Método `private static` em cada handler que converte
   Entity → Proto DTO, usando `DateTime.SpecifyKind` para timestamps.

7. **Implementar error handling** — Catch `RpcException` re-throw; catch `Exception`
   wrap em `StatusCode.Internal` com mensagem localizada.

8. **Implementar SyncHandler** — Handler incremental que retorna upserted + deletedIds
   + serverTimestamp com filtro por WorkspaceId e UpdatedAt.

9. **Validar input** — Cast com pattern matching, TryParse para GUIDs,
   mensagens via `_localizationService`.

10. **Registrar via MCP** — Toda operação deve ter subtask, logs, diffs e completion.

## Input
- Arquivo `.proto` já criado (contrato gRPC com todos RPCs definidos)
  → Exemplo: `Core/Protos/Command/command.proto`
- Entity model criado (C# class com properties e tipos)
  → Exemplo: `Data/Models/Kyroon/Command.cs`
- Map criado (Fluent API configuration)
  → Exemplo: `Data/Models/Kyroon/Maps/CommandMap.cs`
- IDs de contexto MCP: workspaceId, projectId, taskId, subtaskId
- Nome do domínio em PascalCase (ex: "Medication", "Appointment")

## Output
- `Core/Services/{Domain}/{Domain}GrpcService.cs`
- `Core/Services/{Domain}/{Domain}ServiceExtensions.cs`
- `Core/Services/{Domain}/Create{Domain}/{Domain}CreateHandler.cs`
- `Core/Services/{Domain}/Update{Domain}/{Domain}UpdateHandler.cs`
- `Core/Services/{Domain}/Delete{Domain}/{Domain}DeleteHandler.cs`
- `Core/Services/{Domain}/Get{Domain}/{Domain}GetHandler.cs`
- `Core/Services/{Domain}/List{Domain}s/{Domain}ListHandler.cs`
- `Core/Services/{Domain}/Dropdown{Domain}s/{Domain}DropdownHandler.cs`
- `Core/Services/{Domain}/Sync{Domain}s/{Domain}SyncHandler.cs`
- Modificação: `Program.cs` (+2 linhas: DI + MapGrpcService)

## File Creation Checklist

Para cada novo domínio "{Domain}", este agent cria:

Core/Services/{Domain}/
├── {Domain}GrpcService.cs
├── {Domain}ServiceExtensions.cs
├── Create{Domain}/
│   └── {Domain}CreateHandler.cs
├── Update{Domain}/
│   └── {Domain}UpdateHandler.cs
├── Delete{Domain}/
│   └── {Domain}DeleteHandler.cs
├── Get{Domain}/
│   └── {Domain}GetHandler.cs
├── List{Domain}s/
│   └── {Domain}ListHandler.cs
├── Dropdown{Domain}s/
│   └── {Domain}DropdownHandler.cs
└── Sync{Domain}s/
    └── {Domain}SyncHandler.cs

## Rules

### gRPC Service Rules
1. SEMPRE usar `[Authorize]` no class-level do service (exceto AuthGrpcService)
2. Injetar TODOS handlers via constructor (um parâmetro por handler)
3. Usar FlowStepsChain para delegação — ZERO lógica no service
4. Namespace: `Kyroon.Enterprise.Server.Core.Services.{Domain}`

### Handler Rules
5. Implementar `ICommand`: `Task<(bool, object)> Execute(object input)`
6. Cast de input com pattern matching — throw `InvalidArgument` se inválido
7. SEMPRE extrair userId: `var userId = _httpContextAccessor.GetUserId();`
8. SEMPRE validar WorkspaceId: `Guid.TryParse(request.WorkspaceId, out var workspaceId)`
9. UUID deduplication no CreateHandler (OBRIGATÓRIO para offline-first)
10. Todas mensagens via `_localizationService.GetString(ResourceKeys.{Domain}.{Key})`
11. MapToDto é `private static` — converte Entity → Proto DTO
12. DateTime → Timestamp: `Timestamp.FromDateTime(DateTime.SpecifyKind(dt, DateTimeKind.Utc))`
13. Catch `RpcException` re-throw; catch `Exception` wrap em `StatusCode.Internal`
14. Nullable fields: verificar `.HasValue` antes de converter para Timestamp

### DI Rules
15. Todos handlers registrados como `AddScoped<>()` (não Singleton, não Transient)
16. Método nomeado `Add{Domain}Handlers(this IServiceCollection services)`
17. Retorna `IServiceCollection` para chaining

### Sync Rules
18. SyncHandler recebe: lastSyncTimestamp, localIds[], workspaceId
19. Query: `WHERE WorkspaceId == wid AND UpdatedAt > lastSync`
20. deletedIds = localIds que não existem no banco (hard-deleted)
21. Retorna: upserted[] + deletedIds[] + serverTimestamp
22. CRITICAL: localIds deve conter APENAS IDs do MESMO domínio

### Security Rules
23. NUNCA confiar em userId/workspaceId do request body — extrair do token
24. SEMPRE filtrar por WorkspaceId em toda query (multi-tenancy)
25. SEMPRE excluir `IsDeleted == true` em List e Get

## Reference Files

ANTES de implementar qualquer código, LEIA OBRIGATORIAMENTE estes arquivos:

| # | Arquivo | O que aprender |
|---|---------|---------------|
| 1 | `Core/Services/Command/CommandGrpcService.cs` | Padrão de thin service com FlowStepsChain |
| 2 | `Core/Services/Command/CreateCommand/CommandCreateHandler.cs` | Padrão de CreateHandler com UUID dedup |
| 3 | `Core/Services/Agent/SyncAgents/AgentSyncHandler.cs` | Padrão de SyncHandler incremental |
| 4 | `Core/Services/Command/CommandServiceExtensions.cs` | Padrão de DI extension |
| 5 | `Program.cs` | Onde registrar DI e MapGrpcService |

## Common Mistakes

| # | Erro | Por que é problema | Correção |
|---|------|-------------------|----------|
| 1 | Colocar lógica no GrpcService | Viola thin-service, dificulta testes | Toda lógica nos handlers |
| 2 | Esquecer UUID dedup no Create | Duplicatas em cenário offline-first | Checar `request.Uuid` |
| 3 | Usar `Guid.Parse` sem TryParse | Crash em input inválido | Sempre `Guid.TryParse` |
| 4 | Esquecer `DateTime.SpecifyKind` | Crash em conversão Timestamp | SpecifyKind(dt, Utc) |
| 5 | Não filtrar por WorkspaceId | Vazamento cross-tenant | WHERE WorkspaceId == wid |
| 6 | Esquecer `!e.IsDeleted` | Retorna entidades deletadas | .Where(e => !e.IsDeleted) |
| 7 | Handler como Singleton | DbContext Scoped + Singleton = crash | AddScoped<>() |
| 8 | Esquecer MapGrpcService | Service não responde | app.MapGrpcService<>() |
| 9 | Mensagens hardcoded | Não traduzíveis | ResourceKeys.{Domain}.{Key} |
| 10 | Esquecer [Authorize] | Endpoint público = breach | [Authorize] class-level |

## MCP Traceability Protocol

Refer to '.claude/kyroon/mcp-kyroon.md' for full parameter details on each method.

### Ao Iniciar Trabalho
- Call MCP Kyroon - CreateSubtask com: workspaceId, taskId, agentName, title, sequence → Salvar subtask_id

### Durante o Trabalho
- Call MCP Kyroon - LogSubtask com: subtaskId, level: "info", mensagem de progresso

### Após Cada Arquivo
- Call MCP Kyroon - AttachDiff com: subtaskId, filePath, diff, action: "created|modified|deleted"

### Ao Concluir
- Call MCP Kyroon - CompleteSubtask com: subtaskId, outputJson, filesRead, filesChanged, durationMs

### Em Caso de Erro
- Call MCP Kyroon - FailSubtask com: subtaskId, errorMessage, errorStack
```

---

### 13.2 Modelo Completo de Skill — handler-patterns (exemplo REAL)

```markdown
---
name: handler-patterns
description: >-
  Padrões de command handler do Kyroon Enterprise Server incluindo ICommand interface,
  estrutura de CRUD handlers, delegação FlowStepsChain, UUID deduplication, DI registration,
  e regras de handler. Use quando implementando lógica de negócio em handlers.
user-invocable: false
---

# Handler Patterns — Kyroon Enterprise Server

## ICommand Interface

Todos handlers implementam esta interface:

```csharp
// Source: Core/Interfaces/ICommand.cs
public interface ICommand
{
    Task<(bool, object)> Execute(object input);
}
```

Retorno: `(bool success, object result)`.
O result é o DTO de resposta tipado (ex: CommandResponse).

## Estrutura de CreateHandler

```csharp
// Source: Core/Services/Command/CreateCommand/CommandCreateHandler.cs
// CÓDIGO REAL COMPLETO — use como modelo

namespace Kyroon.Enterprise.Server.Core.Services.Command.CreateCommand;

public class CommandCreateHandler : ICommand
{
    private readonly ILogger<CommandCreateHandler> _logger;
    private readonly ApplicationDbContext _db;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IStringLocalizer _localizationService;

    public CommandCreateHandler(
        ILogger<CommandCreateHandler> logger,
        ApplicationDbContext db,
        IHttpContextAccessor httpContextAccessor,
        IStringLocalizer localizationService)
    {
        _logger = logger;
        _db = db;
        _httpContextAccessor = httpContextAccessor;
        _localizationService = localizationService;
    }

    public async Task<(bool, object)> Execute(object input)
    {
        if (input is not CreateCommandRequest request)
            throw new RpcException(new Status(StatusCode.InvalidArgument,
                "Invalid input type"));

        var userId = _httpContextAccessor.GetUserId();
        if (!Guid.TryParse(request.WorkspaceId, out var workspaceId))
            throw new RpcException(new Status(StatusCode.InvalidArgument,
                _localizationService.GetString(ResourceKeys.Validation.InvalidWorkspaceId)));

        // UUID deduplication (offline-first support)
        if (!string.IsNullOrEmpty(request.Uuid))
        {
            var existing = await _db.Commands
                .FirstOrDefaultAsync(e => e.ClientUuid == Guid.Parse(request.Uuid)
                    && e.WorkspaceId == workspaceId);
            if (existing != null)
                return (true, MapToDto(existing));
        }

        var entity = new Data.Models.Kyroon.Command
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            WorkspaceId = workspaceId,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            IsDeleted = false
        };

        _db.Commands.Add(entity);
        await _db.SaveChangesAsync();
        return (true, MapToDto(entity));
    }

    private static CommandResponse MapToDto(Data.Models.Kyroon.Command entity)
    {
        return new CommandResponse
        {
            Id = entity.Id.ToString(),
            CreatedAt = Timestamp.FromDateTime(
                DateTime.SpecifyKind(entity.CreatedAt, DateTimeKind.Utc)),
            UpdatedAt = entity.UpdatedAt.HasValue
                ? Timestamp.FromDateTime(
                    DateTime.SpecifyKind(entity.UpdatedAt.Value, DateTimeKind.Utc))
                : null
        };
    }
}
```

## Por que FlowStepsChain e não chamada direta?

O FlowStepsChain permite composição de steps sem acoplamento:
- Step único para handlers simples (CRUD)
- Multi-step para operações complexas (Validate → Execute → Notify)

## Anti-Patterns

### ❌ ERRADO: Lógica no GrpcService
```csharp
public override async Task<CommandResponse> CreateCommand(
    CreateCommandRequest request, ServerCallContext context)
{
    var entity = new Command { Name = request.Name };
    _db.Commands.Add(entity);
    await _db.SaveChangesAsync();
    return MapToDto(entity);
}
```

### ✅ CORRETO: Delegação via FlowStepsChain
```csharp
public override async Task<CommandResponse> CreateCommand(
    CreateCommandRequest request, ServerCallContext context)
{
    return (await _flowSteps
        .AddStepAsync(_createHandler.Execute)
        .ExecuteTypedAsync<CommandResponse>(input: request)).Item2;
}
```

## Rules
1. Todo handler herda de ICommand
2. Input é cast via pattern matching (is not → throw InvalidArgument)
3. UserId SEMPRE via _httpContextAccessor.GetUserId()
4. WorkspaceId SEMPRE via Guid.TryParse
5. CreateHandler SEMPRE com UUID deduplication
6. MapToDto SEMPRE private static
7. DateTime SEMPRE com SpecifyKind(dt, DateTimeKind.Utc) antes de Timestamp.FromDateTime
8. Todos handlers registrados como AddScoped<>()
```

---

### 13.3 Modelo Completo de Command — new-grpc-service (exemplo REAL)

```markdown
---
description: >-
  Gera um CRUD gRPC completo para uma nova entidade incluindo: proto contract,
  entity + map + migration, thin gRPC service, 7 command handlers (Create com UUID dedup,
  Update, Delete, Get, List, Dropdown, Sync), DI extension e registro no Program.cs.
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
argument-hint: "[EntityName] schema: [schema] fields: [name(type), ...]"
---

# Command: /new-grpc-service

## Usage

/new-grpc-service "EntityName" schema: schema_name fields: field1(type), field2(type?), ...

### Exemplos Reais

# Entidade clínica
/new-grpc-service "Medication" schema: clinical fields: name(string), dosage(string?), frequency(int)

# Entidade de agendamento
/new-grpc-service "Appointment" schema: scheduling fields: title(string), start_at(datetime), patient_id(guid)

# Entidade simples
/new-grpc-service "Category" schema: core fields: name(string), color(string?), sort_order(int)

## Execution Flow

### Phase 1 — Proto Generation (orchestrator)
- Cria o arquivo `.proto` com o contrato gRPC
- 7 RPCs: Create, Update, Delete, Get, List, Dropdown, Sync
- Adiciona `<Protobuf>` no .csproj

### Phase 2 — Entity & Map (database-specialist)
- Cria entity class com base properties
- Cria Fluent API map
- Gera migration

### Phase 3 — Handlers & Service (dotnet-specialist)
- Cria 7 handlers (ICommand)
- Cria thin GrpcService
- Cria DI extension
- Atualiza Program.cs

### Phase 4 — Validation (validator)
- Verifica build (`dotnet build`)
- Valida checklist de patterns

### Phase 5 — Tests (qa-specialist)
- Cria unit tests para handlers
- Executa tests (`dotnet test`)

## Approval Gates

| Fase | Condição | O Que é Revisado |
|------|----------|-----------------|
| Proto | > 15 campos ou tipos complexos | Contrato gRPC |
| Entity | FKs cross-schema | Entity + Map |
| Handlers | Lógica custom | Handlers CRUD |

## Validation Checklist

- [ ] `dotnet build` sem erros
- [ ] 9 arquivos de handler existem
- [ ] GrpcService é thin
- [ ] CreateHandler tem UUID dedup
- [ ] Todos filtram por WorkspaceId
- [ ] SyncHandler retorna upserted + deletedIds

## Rollback Strategy

| Fase | Remover | Reverter |
|------|---------|----------|
| Proto | `.proto` file | `<Protobuf>` do .csproj |
| Entity | Entity + Map | DbSet + migration |
| Handlers | `Core/Services/{Domain}/` | Program.cs |

## Output Summary Template

/new-grpc-service completado
Entity: {Entity} (schema: {schema})
Arquivos criados: 14
Arquivos modificados: 2
Build: ✅ Passed
```

---

## 14. Integração entre Documentos

### 14.1 Mapa de Referências Cruzadas

Os documentos da infraestrutura Kyroon AI estão interligados. Use estas referências para navegação:

| Documento | Localização | Conteúdo | Referenciado por |
|-----------|------------|----------|-----------------|
| **flow_generation.md** | `Kyroon.Enterprise.Server.Worker/Prompts/` | Regras de persistência + qualidade + critérios de aceite | super-architect.md |
| **super-architect.md** | `kyroon_app/assets/claude/agents/` | Agent responsável por gerar times | flow_generation.md |
| **mcp-kyroon.md** | `Kyroon.Enterprise.Server.Worker/Prompts/` | Catálogo de MCP tools e protocolos | super-architect.md, flow_generation.md |

### 14.2 Quem Faz o Quê

```
flow_generation.md:
  → DEFINE as regras de persistência e qualidade
  → DEFINE os critérios de aceite
  → DEFINE os templates e modelos completos
  → DEFINE o scoring de especialização
  → É CONSUMIDO pelo super-architect quando gera times

super-architect.md:
  → IMPLEMENTA as regras definidas em flow_generation.md
  → ORQUESTRA a geração completa de times
  → CHAMA as MCP tools definidas em mcp-kyroon.md
  → VALIDA artefatos usando critérios de flow_generation.md
  → GERA o relatório de especialização

mcp-kyroon.md:
  → DOCUMENTA as tools MCP disponíveis
  → DEFINE os parâmetros e retornos de cada tool
  → DEFINE as regras de rastreabilidade
  → É CONSUMIDO por super-architect.md e por todos agents gerados
```

### 14.3 Fluxo de Leitura Recomendado

```
Para entender o SISTEMA COMPLETO:
  1. Ler mcp-kyroon.md (tools disponíveis)
  2. Ler flow_generation.md (regras e critérios)
  3. Ler super-architect.md (como tudo se integra)

Para GERAR UM TIME:
  1. Super-architect lê flow_generation.md (internalizar regras)
  2. Super-architect usa mcp-kyroon.md (chamar tools)
  3. Super-architect segue o protocolo de flow_generation.md (persistir + validar)
  4. Super-architect apresenta relatório de especialização (scoring)

Para EXECUTAR UM COMMAND:
  1. Agent lê suas skills vinculadas (knowledge)
  2. Agent usa mcp-kyroon.md (rastreabilidade)
  3. Agent segue as regras de seu .md (identity + rules)
  4. Agent reporta via MCP (subtask + logs + diffs)
```

---

## 15. Recomendações Técnicas de Padronização

### 15.1 Convenções de Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-----------|---------|
| Agent name | kebab-case, lowercase | `dotnet-specialist`, `bug-investigator` |
| Skill name | kebab-case, lowercase | `grpc-patterns`, `ef-core-patterns` |
| Command name | kebab-case, lowercase, sem barra | `new-grpc-service`, `fix-bug` |
| Agent file | `{agent-name}.md` | `dotnet-specialist.md` |
| Skill file | `{skill-name}/SKILL.md` | `grpc-patterns/SKILL.md` |
| Command file | `{command-name}.md` | `new-grpc-service.md` |
| YAML field names | kebab-case | `allowed-tools`, `argument-hint` |
| YAML field values (enum) | English only | `specialist`, `orchestrator` |
| Seções do conteúdo | Title Case com `##` | `## Common Mistakes` |

### 15.2 Estrutura de Diretórios Obrigatória

```
{ProjectPath}/
└── .claude/
    ├── agents/
    │   ├── orchestrator.md
    │   ├── dotnet-specialist.md
    │   ├── database-specialist.md
    │   ├── bug-investigator.md
    │   ├── validator.md
    │   └── qa-specialist.md
    ├── commands/
    │   ├── new-grpc-service.md
    │   ├── new-feature.md
    │   ├── fix-bug.md
    │   ├── review-code.md
    │   └── architect.md
    └── skills/
        ├── project-structure/
        │   └── SKILL.md
        ├── grpc-patterns/
        │   └── SKILL.md
        ├── handler-patterns/
        │   └── SKILL.md
        ├── ef-core-patterns/
        │   └── SKILL.md
        ├── sync-patterns/
        │   └── SKILL.md
        └── error-handling-pattern/
            └── SKILL.md
```

### 15.3 Versionamento

- Cada geração de time incrementa o número do flow (ex: "Development Pipeline v2")
- Ao atualizar agents existentes, usar `UpdateAgent` (não recriar)
- Ao atualizar commands existentes, usar `UpdateCommand` (não recriar)
- Manter histórico de alterações via `AttachDiff` para auditoria

### 15.4 Robustez

- Sempre verificar existência de diretório antes de Write (`mkdir -p`)
- Sempre verificar tamanho após Write (`wc -l`)
- Sempre usar o MESMO conteúdo no disco e no MCP (`contentMd`)
- Sempre vincular ao flow via `flowId`
- Sempre linkar skills relevantes a agents via `LinkSkillToAgent`
- Sempre registrar diffs via `AttachDiff` para auditoria completa
- Em caso de falha parcial: logar o erro, marcar subtask como falhada, continuar com próximo artefato
