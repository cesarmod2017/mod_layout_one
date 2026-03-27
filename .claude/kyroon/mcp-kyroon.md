# Kyroon MCP Tools — Guia de Uso

Você tem acesso às tools do MCP Kyroon para gerenciar projetos, tasks, agents, commands e flows.
Use estas tools para registrar todo o trabalho realizado, garantindo rastreabilidade completa no dashboard.

> **Regra fundamental:** Sempre que uma operação gerar trabalho que precisa ser rastreado (criar agents, executar commands, modificar arquivos), você DEVE criar subtasks via MCP para registrar cada ação.

> **⛔ REGRA CRÍTICA — PROIBIDO CRIAR PROJETOS:**
> A tool `CreateProject` **NÃO DEVE ser chamada por agents**.
> Projetos são criados **EXCLUSIVAMENTE pelo usuário** na plataforma Kyroon.
> O `projectId` e `workspaceId` são fornecidos no contexto da task (arquivo `.tasks/task-*.md`).
> Se não existirem no contexto, use `GetWorkerIdentity` para obter o `workspaceId`
> e **PARE** — solicite ao usuário qual projeto usar via `RequestApproval` ou mensagem direta.
> **NUNCA** crie um projeto novo por conta própria. Isso corrompe a rastreabilidade do dashboard.

> **Documentos relacionados:**
> - **Regras de persistência e qualidade de conteúdo**: Veja `.claude/kyroon/flow_generation.md` — define regras obrigatórias de dupla escrita (Write + MCP), critérios de aceite, scoring de especialização, e modelos completos de referência.
> - **Agent orquestrador de geração de times**: Veja `.claude/agents/super-architect.md` — o agent responsável por gerar times completos de agents, skills e commands seguindo as regras de `flow_generation.md`.

---

## 1. ProjectTools

Gerenciamento de projetos no Kyroon.

> **ATENÇÃO:** As tools desta seção são de uso **restrito**. Leia as regras de cada uma antes de usar.

### CreateProject — ⛔ USO RESTRITO (SOMENTE PELO USUÁRIO)

> **NUNCA chame CreateProject de dentro de um agent ou command.**
> Projetos são criados pelo usuário na plataforma Kyroon.
> O `projectId` já está disponível no contexto da task. Use-o diretamente.
> Se precisar verificar se o projeto existe, use `GetProject` com o `projectId` do contexto.

Cria ou registra um projeto. Retorna o `project_id` necessário para todas as outras operações.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| name | string | Sim | Nome do projeto |
| rootPath | string | Sim | Caminho raiz do projeto no filesystem |
| slug | string | Não | Slug URL-friendly (auto-gerado do name se omitido) |
| description | string | Não | Descrição do projeto |
| stackJson | string | Não | Tech stack como JSON (ex: `{"backend":"dotnet","frontend":"flutter"}`) |
| repositoryUrl | string | Não | URL do repositório Git |

**Retorno:** `{ project_id, name, root_path, message }`

**Exemplo:**
```
CreateProject(
  workspaceId: "df71617f-...",
  name: "Meu Projeto",
  rootPath: "/home/user/projects/meu-projeto",
  stackJson: "{\"backend\":\"dotnet\",\"frontend\":\"flutter\"}"
)
```

### GetProject

Busca um projeto por ID. Útil para verificar se um projeto existe antes de criar agents.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| projectId | string (UUID) | Sim | ID do projeto |

**Retorno:** `{ project_id, workspace_id, name, description, root_path, repository_url, stack, status, created_at }`

---

## 2. TaskTools

Gerenciamento de tasks, subtasks e hierarquia de tarefas — o coração da rastreabilidade.

### Modelo TaskItem — Campos Importantes

| Campo | Tipo | Descrição |
|---|---|---|
| Id | Guid | Identificador único da task |
| WorkspaceId | Guid | Workspace ao qual a task pertence |
| ProjectId | Guid | Projeto ao qual a task pertence |
| FlowId | Guid? | Flow vinculado (opcional) |
| Title | string | Título descritivo |
| Description | string? | Descrição detalhada |
| Type | string | Tipo: `feature`, `bugfix`, `refactor`, `review`, `architect`, `custom`, `flow_generation` |
| Status | string | Status atual (ver tabela de transições abaixo) |
| Priority | string | Prioridade: `low`, `medium`, `high`, `critical` |
| InputData | string | Dados de entrada como JSON |
| **FinalReport** | string? | Relatório final gerado ao concluir a task. Contém o output do plan mode ou resumo da execução |
| **IsPlanMode** | bool | Se `true`, o Worker executa a task em modo planejamento (`-permission-mode plan`). O output é salvo em `FinalReport` |
| **TaskParentId** | Guid? | FK para a task pai. Estabelece hierarquia parent/child entre tasks |
| WorkerAgentId | Guid? | FK para o WorkerAgent que executa a task |
| WorkspaceSequenceNumber | int | Número sequencial dentro do workspace (auto-gerenciado) |
| CreatedBy | string | Quem criou: `user` ou `agent` |
| StartedAt | DateTime? | Quando a execução iniciou |
| FinishedAt | DateTime? | Quando a execução terminou |

### Transições de Status

| Status | Descrição | Próximos Possíveis |
|---|---|---|
| `new` | Criada, aguardando início | `in_progress` |
| `in_progress` | Em execução pelo Worker/Agent | `validation`, `failed` |
| `validation` | Aguardando revisão ou aprovação humana | `done`, `failed` |
| `done` | Concluída com sucesso | — (terminal) |
| `failed` | Falha, timeout, cancelada ou rejeitada | — (terminal) |

> **Regra de transição:** Quando `in_progress`, a task SEMPRE vai para `validation` (sucesso) ou `failed` (erro/cancelamento). Não há mais `cancelled`, `timeout`, `approved`, `completed`, `pending` ou `waiting_approval` como status válidos.
>
> **Mapeamento de status legados:**
> - `pending` → `new`
> - `running` → `in_progress`
> - `waiting_approval` → `validation`
> - `approved`, `completed` → `done`
> - `rejected`, `timeout`, `cancelled` → `failed`

### Hierarquia de Tasks (Parent/Child)

O campo `TaskParentId` permite criar cadeias de tasks vinculadas:

```
Task Pai (IsPlanMode=true) ──→ Executa análise/planejamento
   │                              FinalReport = relatório da análise
   │
   └── Task Filha (TaskParentId = Id do pai)
          Description = conteúdo do FinalReport do pai
          Status = pending (aguardando aprovação/execução)
```

**Fluxo típico:**
1. Task pai executa em plan mode → gera relatório de análise
2. `CompleteTaskAndCreateFollowUp` é chamada:
   - Salva o `FinalReport` no pai
   - Atualiza status do pai para `completed` ou `waiting_approval`
   - Cria task filha com `TaskParentId` apontando para o pai
   - `Description` da filha recebe o conteúdo do `FinalReport` (se não informada)
3. Usuário revê a task filha no dashboard, entende a origem e toma decisão
4. Se aprovado, a task filha é enviada para execução

---

### GetWorkerIdentity

Retorna a identidade do WorkerAgent autenticado via API Key. Use para descobrir o `workspace_id` associado ao worker.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| — | — | — | Nenhum parâmetro |

**Retorno:** `{ worker_agent_id, workspace_id, authenticated, message }`

---

### CreateTask

> **⚠️ REGRA IMPORTANTE — CreateTask é RESTRITO ao orchestrator:**
> Sub-agents (specialist, validator, qa, investigator) **NÃO DEVEM chamar CreateTask**.
> O `taskId` já existe no contexto da execução (`.tasks/task-*.md` ou prompt do orchestrator) — use-o diretamente em `CreateSubtask`.
> Somente o **orchestrator** pode chamar `CreateTask`, e APENAS se `taskId` não existir no contexto.
> Se você recebeu `taskId` no seu prompt ou contexto, use-o. NÃO crie uma task nova.

Cria uma task principal. Chame no início de qualquer operação de agent. Retorna o `task_id` que deve ser passado a todas as subtasks.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| projectId | string (UUID) | Sim | ID do projeto |
| title | string | Sim | Título descritivo da task |
| type | string | Não | Tipo: `feature`, `bugfix`, `refactor`, `review`, `architect`, `custom` (default: `custom`) |
| priority | string | Não | Prioridade: `low`, `medium`, `high`, `critical` (default: `medium`) |
| description | string | Não | Descrição detalhada |
| inputDataJson | string | Não | Dados de entrada como JSON |
| flowId | string (UUID) | Não | Vincula a task a um flow para rastreabilidade visual no canvas |

**Retorno:** `{ task_id, title, status, message }`

**Regras:**
- Status inicial é sempre `in_progress`.
- `StartedAt` é preenchido automaticamente com UTC now.
- `CreatedBy` é `agent`.
- `WorkspaceSequenceNumber` é auto-incrementado dentro do workspace.

**Exemplo:**
```
CreateTask(
  workspaceId: "df71617f-...",
  projectId: "66c999b3-...",
  title: "Implementar CRUD de Medicamentos",
  type: "feature",
  priority: "high",
  flowId: "abc123-..."
)
```

---

### UpdateTaskStatus

Atualiza o status de uma task principal.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| taskId | string (UUID) | Sim | ID da task |
| status | string | Sim | Status: `in_progress`, `validation`, `failed` (**agents NÃO podem usar `done`**) |
| finalReportJson | string | Não | Relatório final como JSON (obrigatório quando status=validation) |

**Regras:**
- Use `validation` quando finalizar com sucesso — a task fica aguardando aprovação do usuário.
- ⛔ **NUNCA use `done`** — apenas o usuário pode aprovar e mover para `done`. Se um agent tentar usar `done`, o servidor automaticamente converte para `validation`.
- Use `failed` em caso de erro crítico, timeout ou cancelamento.
- Sempre envie `finalReportJson` ao completar.
- `FinishedAt` é preenchido automaticamente para status `validation`, `done` e `failed`.
- Se status é `in_progress` e `StartedAt` é null, preenche automaticamente.
- Se a task já está em status terminal, a atualização é ignorada (guard contra race conditions).
- Para tasks tipo `flow_generation` com status `done`, enfileira automaticamente atualização de arquivos .md.

---

### CompleteTaskAndCreateFollowUp ⭐ NOVA

Completa uma task pai (salva FinalReport, atualiza status) e cria uma nova task filha vinculada via `TaskParentId`. Use quando a execução de uma task gera um resultado que precisa de revisão humana ou um próximo passo de implementação.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| taskId | string (UUID) | Sim | ID da task pai sendo concluída |
| finalReport | string | Sim | Relatório final / output gerado pela execução da task pai |
| childTitle | string | Sim | Título da nova task filha |
| childDescription | string | Não | Descrição da task filha. Se omitido, herda o conteúdo de `finalReport` |
| childType | string | Não | Tipo da task filha. Se omitido, herda do pai |
| childPriority | string | Não | Prioridade da task filha. Se omitido, herda do pai |
| childIsPlanMode | bool | Não | Se `true`, a task filha executará em plan mode (default: `false`) |
| parentStatus | string | Não | Status final do pai: `validation` (default: `validation`). ⛔ Agents NÃO podem usar `done`. |

**Retorno:** `{ parent_task_id, parent_status, child_task_id, child_title, child_status, child_is_plan_mode, task_parent_id, message }`

**Campos herdados automaticamente do pai:**
- `WorkspaceId`, `ProjectId`, `FlowId`
- `InputData`, `CreatedByUserId`, `AssignedTo`
- `AgentName`, `Command`, `PathsJson`, `WorkerAgentId`
- `Type` e `Priority` (se não informados explicitamente)

**Campos definidos na tarefa filha:**
- `Status` = `pending` (sempre)
- `TaskParentId` = ID da task pai
- `IsPlanMode` = valor informado ou `false`
- `Description` = `childDescription` ou `finalReport` (fallback)
- `CreatedBy` = `agent`

**Regras de negócio:**
1. O `parentStatus` só aceita `done` ou `validation`. Qualquer outro valor gera erro.
2. O `FinalReport` do pai é sempre preenchido com o conteúdo de `finalReport`.
3. O `FinishedAt` do pai é sempre preenchido com UTC now.
4. A task filha recebe `WorkspaceSequenceNumber` incrementado.
5. Para tasks tipo `flow_generation` com `parentStatus=done`, enfileira atualização de arquivos .md.

**Exemplo — Plan Mode → Implementação:**
```
CompleteTaskAndCreateFollowUp(
  taskId: "24dcd5a5-...",
  finalReport: "## Análise\n\n### Arquivos identificados\n- TaskTools.cs\n- TaskItem.cs\n\n### Plano de implementação\n1. Criar nova tool...\n2. Atualizar modelo...",
  childTitle: "[501] Implementar Tool de Task para criar tarefa filha",
  childDescription: "Implementar conforme plano gerado na análise...",
  childType: "feature",
  childPriority: "high",
  childIsPlanMode: false,
  parentStatus: "done"
)
```

**Exemplo — Aguardando Aprovação Humana:**
```
CompleteTaskAndCreateFollowUp(
  taskId: "24dcd5a5-...",
  finalReport: "Refatoração detectou 15 arquivos impactados. Risco: médio. Detalhes...",
  childTitle: "Aprovação: Refatorar módulo de pagamentos",
  childDescription: "Refatoração detectou 15 arquivos impactados...",
  parentStatus: "validation"
)
```

---

### CreateSubtask

Cria uma subtask representando uma ação específica de um agent. Chame ANTES de iniciar a ação.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| taskId | string (UUID) | Sim | ID da task principal |
| agentName | string | Sim | Nome do agent (ex: `dotnet-specialist`) |
| title | string | Sim | Título da ação (ex: `Criar entidade Medicamento`) |
| sequence | int | Sim | Número de sequência (ordem de execução, começa em 1) |
| description | string | Não | Descrição do que será feito |
| requiresApproval | bool | Não | Se true, pausa aguardando aprovação humana (default: false) |
| parentId | string (UUID) | Não | ID da subtask pai — para subtasks aninhadas |
| flowNodeId | string (UUID) | Não | ID do nó no canvas para rastreabilidade visual |
| agentId | string (UUID) | Não | ID do agent registrado que executa esta subtask |

**Retorno:** `{ subtask_id, title, status, message }`

**Regras:**
- Status inicial é sempre `in_progress`.
- Se `agentId` não é informado mas `agentName` é, busca o agent automaticamente pelo nome no projeto.
- Se `flowNodeId` não é informado mas existe `FlowId` na task pai e `agentId` foi resolvido, busca o FlowNode automaticamente.
- Sempre crie uma subtask ANTES de executar qualquer ação significativa.

**Exemplo:**
```
CreateSubtask(
  workspaceId: "df71617f-...",
  taskId: "6aeded52-...",
  agentName: "dotnet-specialist",
  title: "Criar entity Medicamento",
  sequence: 1,
  description: "Criar classe entity com EF Core e mapeamento Fluent API"
)
```

---

### CompleteSubtask

Marca uma subtask como concluída com sucesso. Reporte os arquivos lidos, alterados e o resultado.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| subtaskId | string (UUID) | Sim | ID da subtask |
| outputJson | string | Sim | Resultado da operação como JSON |
| filesRead | string | Não | Arquivos lidos durante a execução (separados por vírgula) |
| filesChanged | string | Não | Arquivos criados ou modificados (separados por vírgula) |
| diff | string | Não | Diff unificado das alterações |
| durationMs | int | Não | Tempo de execução em milissegundos (default: 0) |

---

### FailSubtask

Marca uma subtask como falhada. Reporte a mensagem de erro para rastreabilidade.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| subtaskId | string (UUID) | Sim | ID da subtask |
| errorMessage | string | Sim | Mensagem de erro detalhada |
| errorStack | string | Não | Stack trace do erro |

---

### RequestApproval

Solicita aprovação humana e pausa a execução. Use antes de qualquer alteração em código existente que possa quebrar funcionalidades. A execução SÓ continua após aprovação no dashboard.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| subtaskId | string (UUID) | Sim | ID da subtask |
| diagnosis | string | Sim | Diagnóstico completo como JSON: `root_cause`, `suspect_file`, `suggested_fix`, `files_to_change` |

**Regras:**
- Após chamar RequestApproval, **PARE** e não execute mais nada até receber aprovação.
- A subtask fica com status `pending`.
- A task pai também fica com status `pending`.
- Um log `APPROVAL_GATE` é registrado automaticamente.

---

### LogSubtask

Registra uma mensagem de log/progresso para uma subtask. Use frequentemente para atualizar o canvas em tempo real.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| subtaskId | string (UUID) | Sim | ID da subtask |
| level | string | Sim | Nível: `info`, `warn`, `error`, `debug` |
| message | string | Sim | Mensagem de log |
| metadataJson | string | Não | Metadados adicionais como JSON |

**Exemplo:**
```
LogSubtask(
  subtaskId: "abc-123",
  level: "info",
  message: "Analisando estrutura existente do módulo de pagamentos"
)
```

---

### AttachDiff

Registra um arquivo criado ou modificado pelo agent. Chame após cada alteração de arquivo para rastreabilidade completa.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| subtaskId | string (UUID) | Sim | ID da subtask |
| filePath | string | Sim | Caminho completo do arquivo (ex: `src/Application/Features/...`) |
| diff | string | Sim | Diff completo em formato unified diff |
| action | string | Sim | Ação: `created`, `modified`, `deleted` |

---

## 3. AgentTools

Gerenciamento de agents e skills.

> **Flow-scoped naming (automático)**: Quando `flowId` é fornecido, o servidor automaticamente prefixa o `name`
> técnico com os 8 primeiros caracteres hexadecimais do flowId (ex: `orchestrator` → `a1b2c3d4_orchestrator`).
> Passe o nome ORIGINAL no parâmetro `name` — o servidor adiciona o prefixo.
> O `displayName` NÃO é prefixado e permanece legível na UI.
> Para arquivos em disco, use o nome prefixado: `.claude/agents/{prefix}_{name}.md`.

### CreateAgent

Cria um novo agent no banco de dados. Retorna o `agent_id` necessário para conexões e links de skills.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| projectId | string (UUID) | Sim | ID do projeto |
| name | string | Sim | Nome único do agent (ex: `dotnet-specialist`) |
| type | string | Sim | Tipo: `orchestrator`, `specialist`, `validator`, `qa`, `investigator` |
| description | string | Sim | Descrição do papel do agent |
| contentMd | string | Sim | Conteúdo completo do arquivo .md do agent |
| displayName | string | Não | Nome de exibição na UI (default: name) |
| friendlyName | string | Não | Nome amigável humano (ex: `Cesar Mesquita`) — simula nome de colaborador |
| model | string | Não | Modelo LLM padrão (default: `claude-opus-4-6`) |
| flowId | string (UUID) | Não | Vincula o agent a um flow específico |

**Retorno:** `{ agent_id, name, type, message }`

**Exemplo:**
```
CreateAgent(
  workspaceId: "df71617f-...",
  projectId: "66c999b3-...",
  name: "dotnet-specialist",
  type: "specialist",
  description: "Especialista em .NET Core, EF Core e gRPC",
  contentMd: "# dotnet-specialist\n\n## Role\nEspecialista em backend .NET...",
  model: "claude-opus-4-6"
)
```

### UpdateAgent

Atualiza o conteúdo .md de um agent existente. Use ao evoluir um agent após análise mais profunda do projeto.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| agentId | string (UUID) | Sim | ID do agent |
| contentMd | string | Sim | Novo conteúdo .md completo |
| description | string | Não | Nova descrição |
| friendlyName | string | Não | Novo nome amigável humano |

### ListAgents

Lista todos os agents ativos de um projeto com suas skills vinculadas.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| projectId | string (UUID) | Sim | ID do projeto |

**Retorno:** Array de `{ agent_id, name, display_name, friendly_name, type, description, model, skills: [{ skill_id, name }] }`

### CreateSkill

Cria uma skill (padrão de código extraído do projeto). Retorna `skill_id` para vincular a agents.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| projectId | string (UUID) | Sim | ID do projeto |
| name | string | Sim | Nome da skill (ex: `grpc-patterns`) |
| contentMd | string | Sim | Conteúdo .md completo com padrões reais do projeto |
| domain | string | Não | Domínio (ex: `grpc`, `ef-core`, `flutter`, `cqrs`) |
| displayName | string | Não | Nome de exibição na UI |
| description | string | Não | Descrição curta da skill |
| flowId | string (UUID) | Não | Vincula a skill a um flow específico |

**Retorno:** `{ skill_id, name, message }`

### LinkSkillToAgent

Vincula uma skill a um agent. O agent lerá esta skill antes de qualquer trabalho.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| agentId | string (UUID) | Sim | ID do agent |
| skillId | string (UUID) | Sim | ID da skill |

**Regra:** Se o vínculo já existir, retorna mensagem informativa sem duplicar.

---

## 4. CommandTools

Gerenciamento de commands (slash-commands invocáveis pelo usuário).

> **Flow-scoped naming (automático)**: Mesmo comportamento dos AgentTools — quando `flowId` é fornecido,
> o `name` é prefixado automaticamente pelo servidor. Passe o nome original.
> Para arquivos em disco: `.claude/commands/{prefix}_{name}.md`.

### CreateCommand

Cria um command (ponto de entrada invocável pelo usuário). Commands são os `/slash-commands` que iniciam trabalho de agents.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| projectId | string (UUID) | Sim | ID do projeto |
| name | string | Sim | Nome do command sem barra (ex: `new-grpc-service`) |
| contentMd | string | Sim | Conteúdo completo do arquivo .md |
| displayName | string | Não | Nome de exibição na UI |
| description | string | Não | Descrição curta do que o command faz |
| argumentHint | string | Não | Dica de argumento (ex: `[entity-name]`) |
| allowedTools | string | Não | Tools permitidas separadas por vírgula (ex: `Read, Glob, Grep, Bash, Edit, Write`) |
| agentId | string (UUID) | Não | ID do agent que este command aciona |
| flowId | string (UUID) | Não | Vincula o command a um flow específico |

**Retorno:** `{ command_id, name, message }`

**Exemplo:**
```
CreateCommand(
  workspaceId: "df71617f-...",
  projectId: "66c999b3-...",
  name: "new-crud",
  contentMd: "# /new-crud\n\nCria um CRUD completo para a entidade...",
  description: "Gera CRUD completo com entity, handler, proto e migration",
  argumentHint: "[entity-name]",
  allowedTools: "Read, Glob, Grep, Bash, Edit, Write"
)
```

### UpdateCommand

Atualiza o conteúdo .md de um command existente.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| commandId | string (UUID) | Sim | ID do command |
| contentMd | string | Sim | Novo conteúdo .md completo |
| description | string | Não | Nova descrição |

### ListCommands

Lista todos os commands ativos de um projeto.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| projectId | string (UUID) | Sim | ID do projeto |

**Retorno:** Array de `{ command_id, name, display_name, description, argument_hint, allowed_tools }`

---

## 5. CanvasTools

Gerenciamento do canvas visual (flows, nodes e edges).

### CreateFlow

Cria um flow (canvas de execução) para um projeto. Um flow contém nodes (agents) e edges (conexões).

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| workspaceId | string (UUID) | Sim | ID do workspace |
| projectId | string (UUID) | Sim | ID do projeto |
| name | string | Sim | Nome do flow (ex: `Main Pipeline`) |
| description | string | Não | Descrição do flow |
| triggerCommand | string | Não | Comando trigger (ex: `/new-crud`, `/fix-bug`) |
| commandId | string (UUID) | Não | ID do command que aciona este flow |

**Retorno:** `{ flow_id, name, trigger_command, message }`

### CreateFlowNode

Adiciona um nó de agent ao canvas do flow. Cada nó representa um agent com posição no canvas visual.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| flowId | string (UUID) | Sim | ID do flow |
| agentId | string (UUID) | Sim | ID do agent que este nó representa |
| label | string | Não | Rótulo do nó (default: nome do agent) |
| positionX | double | Não | Posição X no canvas (default: 0) |
| positionY | double | Não | Posição Y no canvas (default: 0) |
| color | string | Não | Código hexadecimal da cor (default: `4F8EF7`) |
| sortOrder | int | Não | Ordem de execução (default: 0) |
| joinType | string | Não | Tipo de join: `none` (default), `all` (AND-join), `any` (OR-join) |

**Retorno:** `{ node_id, flow_id, agent_id, join_type, message }`

**Join Types explicados:**
- `none` — Padrão, entrada única, sem lógica de join.
- `all` — AND-join: o nó aguarda TODOS os predecessores completarem antes de iniciar.
- `any` — OR-join: o nó inicia assim que o PRIMEIRO predecessor completar.

### CreateFlowEdge

Cria uma edge (conexão) entre dois nós no canvas. Define o fluxo de execução entre agents.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| flowId | string (UUID) | Sim | ID do flow |
| sourceNodeId | string (UUID) | Sim | ID do nó de origem |
| targetNodeId | string (UUID) | Sim | ID do nó de destino |
| label | string | Não | Rótulo da edge (ex: `delegates backend`, `validates after`) |
| edgeType | string | Não | Tipo: `sequential` (default), `parallel`, `conditional` |
| condition | string | Não | Expressão de condição (apenas para tipo `conditional`) |

### UpdateNodePosition

Atualiza a posição de um nó no canvas visual.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| nodeId | string (UUID) | Sim | ID do nó |
| x | double | Sim | Posição X |
| y | double | Sim | Posição Y |

### GetCanvasLayout

Retorna o layout completo do canvas de um flow: todos os nós com posições e todas as edges.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| flowId | string (UUID) | Sim | ID do flow |

**Retorno:** `{ flow_id, name, trigger_command, viewport, nodes: [...], edges: [...] }`

### ListFlows

Lista todos os flows de um projeto. Útil para encontrar flows existentes antes de criar novos.

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| projectId | string (UUID) | Sim | ID do projeto |

**Retorno:** Array de `{ flow_id, name, description, trigger_command, status, nodes_count, edges_count }`

---

## Regras e Boas Práticas

### Regra de ouro: IDs do contexto

> **SEMPRE** use `projectId`, `workspaceId` e `taskId` do contexto da task (`.tasks/task-*.md`).
> **NUNCA** chame `CreateProject` para criar novos projetos — projetos são criados pelo usuário.
> **NUNCA** crie tasks para um `projectId` diferente do que está no contexto.

### Regra de delegação: Sub-agents via Agent tool

> **OBRIGATÓRIO:** Quando o orchestrator delega trabalho para sub-agents usando a tool `Agent` do Claude Code,
> o prompt do Agent DEVE incluir explicitamente os IDs do contexto:
>
> ```
> ## Kyroon Context (OBRIGATÓRIO — NÃO crie nova task)
> - taskId: {taskId do contexto}
> - workspaceId: {workspaceId do contexto}
> - projectId: {projectId do contexto}
> - flowId: {flowId do contexto}
>
> Use CreateSubtask com o taskId acima. NUNCA chame CreateTask.
> ```
>
> Sem esses IDs, o sub-agent perde o vínculo com a task original e cria tasks órfãs.
> O sub-agent NUNCA deve chamar `CreateTask` — apenas `CreateSubtask` com o `taskId` recebido.

### Fluxo obrigatório de execução

1. **Antes de qualquer trabalho:** Verifique se já existe uma task (use o `taskId` do contexto). Se não existir, crie com `CreateTask` usando o `projectId` e `workspaceId` do contexto.
2. **Antes de cada ação:** Crie uma subtask com `CreateSubtask` informando o que será feito.
3. **Durante a execução:** Use `LogSubtask` frequentemente para atualizar o progresso no canvas em tempo real.
4. **Após alterar arquivos:** Use `AttachDiff` para registrar cada arquivo criado/modificado/deletado.
5. **Ao concluir a ação:** Chame `CompleteSubtask` com o resultado e lista de arquivos.
6. **Em caso de erro:** Chame `FailSubtask` com a mensagem de erro detalhada.
7. **Ao concluir tudo:** Chame `UpdateTaskStatus` com status `validation` e o relatório final. **IMPORTANTE:** Agents NUNCA devem usar status `done` — apenas o usuário pode aprovar e mover para `done`.
8. **Se precisar criar follow-up:** Use `CompleteTaskAndCreateFollowUp` para concluir a task atual e criar a próxima etapa.

### Quando usar CompleteTaskAndCreateFollowUp

- **Plan mode concluído:** A task rodou em plan mode, gerou um relatório de análise, e agora precisa de uma task de implementação.
- **Decisão humana necessária:** A execução revelou algo que precisa de aprovação do usuário antes de prosseguir.
- **Encadeamento de tasks:** Qualquer cenário onde o resultado de uma task gera a necessidade de uma nova task vinculada.
- **Rastreabilidade de origem:** O vínculo `TaskParentId` permite que o dashboard mostre a cadeia completa de tasks.

### Quando criar subtasks via MCP

- Ao criar agents → registre uma subtask para cada agent criado.
- Ao criar commands → registre uma subtask para cada command criado.
- Ao criar flows/nodes/edges → registre subtasks agrupando operações relacionadas.
- Ao ler e analisar código → registre uma subtask de investigação.
- Ao modificar arquivos → registre uma subtask por grupo lógico de alterações.
- Ao executar comandos (build, test, migration) → registre uma subtask para cada comando.

### Regras de IDs

- Todos os IDs são UUIDs no formato string (ex: `"66c999b3-36dc-4bce-89d0-c18e94f20100"`).
- O `workspaceId`, `projectId` e `taskId` são fornecidos no contexto da task. Use-os em todas as chamadas.
- Guarde os IDs retornados (agent_id, skill_id, flow_id, node_id, etc.) para usar em chamadas subsequentes.

### Regras de aprovação

- Use `RequestApproval` antes de alterar código existente que possa quebrar funcionalidades.
- Após chamar `RequestApproval`, **PARE** e não execute mais nada até receber aprovação.
- A subtask fica com status `pending` até o usuário aprovar no dashboard.
- Alternativamente, use `CompleteTaskAndCreateFollowUp` com `parentStatus: "validation"` para criar uma nova task que requer decisão humana.

### Cenários comuns

**Cenário 1: Criar um pipeline de agents**
```
1. CreateTask → obter task_id
2. CreateSubtask(title: "Criar agents do pipeline")
3. CreateAgent (orchestrator) → obter agent_id_1
4. CreateAgent (specialist) → obter agent_id_2
5. CreateSkill → obter skill_id
6. LinkSkillToAgent(agent_id_2, skill_id)
7. CompleteSubtask
8. CreateSubtask(title: "Montar flow visual")
9. CreateFlow → obter flow_id
10. CreateFlowNode(agent_id_1) → obter node_id_1
11. CreateFlowNode(agent_id_2) → obter node_id_2
12. CreateFlowEdge(node_id_1, node_id_2)
13. CompleteSubtask
14. UpdateTaskStatus(status: "validation")
```

**Cenário 2: Executar um command com rastreabilidade**
```
1. CreateSubtask(title: "Executar /new-crud Medicamento")
2. LogSubtask(level: "info", message: "Analisando entidades existentes")
3. [... executar trabalho ...]
4. AttachDiff(filePath: "src/Domain/Entities/Medicamento.cs", action: "created", diff: "...")
5. AttachDiff(filePath: "src/Application/Handlers/MedicamentoHandler.cs", action: "created", diff: "...")
6. CompleteSubtask(outputJson: "{\"files_created\": 5}", filesChanged: "Entity.cs,Handler.cs,...")
```

**Cenário 3: Investigação e diagnóstico**
```
1. CreateSubtask(title: "Investigar bug no módulo de pagamentos")
2. LogSubtask(level: "info", message: "Lendo PaymentService.cs")
3. LogSubtask(level: "warn", message: "Encontrada race condition na linha 142")
4. RequestApproval(diagnosis: "{\"root_cause\":\"Race condition em ProcessPayment\",\"suspect_file\":\"PaymentService.cs\",\"suggested_fix\":\"Adicionar lock\"}")
5. [PARAR — aguardar aprovação]
```

**Cenário 4: Plan Mode → Implementação (usando CompleteTaskAndCreateFollowUp)**
```
1. [Task pai com IsPlanMode=true é executada pelo Worker]
2. [Agent analisa código, gera relatório de planejamento]
3. CompleteTaskAndCreateFollowUp(
     taskId: "parent-id",
     finalReport: "## Plano\n1. Criar entity...\n2. Criar handler...",
     childTitle: "Implementar CRUD conforme plano",
     childType: "feature",
     parentStatus: "validation"
   )
4. [Task filha aparece no dashboard com status "new"]
5. [Usuário revisa, aprova, e o Worker executa a task filha]
```

**Cenário 5: Task que requer decisão humana**
```
1. [Task detecta cenário com múltiplas opções]
2. CompleteTaskAndCreateFollowUp(
     taskId: "parent-id",
     finalReport: "Detectei 3 possíveis abordagens:\nA) Refatorar...\nB) Criar novo...\nC) Migrar...",
     childTitle: "Decisão: Escolher abordagem de refatoração",
     childDescription: "Por favor, revise as 3 opções e escolha a abordagem desejada...",
     parentStatus: "validation"
   )
3. [Usuário vê a task no dashboard, lê o FinalReport do pai, entende o contexto]
4. [Usuário toma a decisão e ativa a task filha]
```

---

## Referências Cruzadas

### Documentos do Ecossistema Kyroon AI

Este documento (`mcp-kyroon.md`) faz parte de um conjunto de 3 documentos que definem a infraestrutura de IA do Kyroon:

| Documento | Localização (deployed) | Conteúdo | Quando Consultar |
|-----------|------------|----------|-----------------|
| **mcp-kyroon.md** (este) | `.claude/kyroon/mcp-kyroon.md` | Catálogo completo de MCP tools, parâmetros, retornos e protocolos de rastreabilidade | Quando precisar chamar qualquer MCP tool |
| **flow_generation.md** | `.claude/kyroon/flow_generation.md` | Regras de persistência física (Write + MCP), qualidade de conteúdo, critérios de aceite, scoring de especialização (0-100), modelos completos de referência para agents/skills/commands | Quando gerar artefatos `.claude/` (agents, skills, commands) |
| **super-architect.md** | `.claude/agents/super-architect.md` | Agent orquestrador que gera times completos. Implementa as regras de `flow_generation.md` usando as tools de `mcp-kyroon.md` | Quando precisar entender o fluxo end-to-end de geração de times |

### Regra Crítica de Persistência

> **IMPORTANTE**: Ao usar `CreateAgent`, `CreateSkill` ou `CreateCommand`, lembre-se da regra de **dupla escrita** definida em `flow_generation.md`:
> 1. **PRIMEIRO** escrever o arquivo `.md` no disco via tool `Write`
> 2. **DEPOIS** registrar no MCP com o **MESMO conteúdo** via `contentMd`
>
> O Claude Code CLI lê arquivos **DO DISCO**. Um registro no MCP sem arquivo no disco **NÃO FUNCIONA**.

### Regra de Qualidade de Conteúdo

> **IMPORTANTE**: Os artefatos gerados devem seguir os requisitos mínimos de `flow_generation.md`:
> - Agents: ≥ 150 linhas, com Identity (5-8 frases), Rules (15-25 regras), Common Mistakes (5-10 erros)
> - Skills: ≥ 200 linhas, com 5+ exemplos de código REAL com `// Source:` anotado
> - Commands: ≥ 100 linhas, com Usage (3+ exemplos), Approval Gates, Rollback Strategy
>
> Conteúdo genérico tipo "Especialista em X" sem regras ou exemplos concretos é **PROIBIDO**.

### Índice de Seções Relevantes em flow_generation.md

| Seção | Conteúdo |
|-------|----------|
| §1 | Persistência física obrigatória (dupla escrita, verificação, caminhos) |
| §2 | Qualidade de conteúdo (regra de ouro, processo de extração) |
| §3 | Requisitos mínimos por tipo (agents, commands, skills — com exemplos) |
| §4 | Checklist de qualidade (tabelas de verificação) |
| §5 | Processo de geração completo (fases de leitura, geração, verificação) |
| §10 | Critérios de aceite (Definition of Done, rejeição automática) |
| §11 | Validação de especialização (scoring 0-100, ações corretivas) |
| §12 | Fluxo de geração de times (diagrama completo) |
| §13 | Modelos completos de referência (agent, skill, command) |
| §14 | Integração entre documentos (mapa de referências) |
| §15 | Recomendações técnicas de padronização |
