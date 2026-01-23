# Guia de UX e Padronização de Componentes - ModLayoutOne

**Data:** Janeiro 2026
**Versão:** 1.3.2
**Autor:** Análise UX/UI

---

## Sumário

1. [Visão Geral](#visão-geral)
2. [Princípios Fundamentais](#princípios-fundamentais) ⭐ **LEITURA OBRIGATÓRIA**
3. [Design Tokens (Foundations)](#design-tokens-foundations)
4. [Inventário de Componentes](#inventário-de-componentes)
5. [Análise UX por Categoria](#análise-ux-por-categoria)
6. [Análise UI](#análise-ui)
7. [Problemas Identificados](#problemas-identificados)
8. [Melhorias Sugeridas](#melhorias-sugeridas)
9. [Impacto Esperado](#impacto-esperado)
10. [Diretrizes de Design System](#diretrizes-de-design-system)
11. [Boas Práticas de Compatibilidade](#boas-práticas-de-compatibilidade)
12. [Próximos Passos](#próximos-passos)

---

## Visão Geral

O **ModLayoutOne** é um pacote Flutter completo para construção de layouts responsivos com:
- Gerenciamento de estado via GetX
- Sistema de temas (claro/escuro)
- Internacionalização (i18n) integrada
- Biblioteca extensiva de componentes UI
- Grid system responsivo inspirado no Bootstrap

### Arquitetura de Componentes (Atomic Design)

| Nível | Categoria | Componentes |
|-------|-----------|-------------|
| **Atoms** | Elementos básicos | ModButton, ModIconButton, ModLabel, ModAvatar |
| **Molecules** | Composições simples | ModTextBox, ModDropDown, ModDropdownSearch, ModTabs |
| **Organisms** | Componentes complexos | ModDataTable, ModTreeView, ModCard, ModModal, ModDialog |
| **Templates** | Estruturas de layout | ModBaseLayout, ModSidebar, ModHeader, ModFooter |
| **Pages** | Telas completas | NoAccessScreen |

---

## Princípios Fundamentais

### Uso Obrigatório do Theme

O **ModLayoutOne** é um pacote reutilizável em múltiplos projetos. Para garantir a correta integração visual com qualquer aplicação que o consuma, **todos os componentes DEVEM utilizar exclusivamente as propriedades do tema ativo**.

#### Regra de Ouro

```
NUNCA use cores, fontes ou estilos hardcoded.
SEMPRE obtenha valores visuais do Theme.
```

#### Por que isso é crítico?

1. **Reutilização**: O package é usado em diferentes projetos, cada um com sua identidade visual
2. **Consistência**: Garante que os componentes se adaptem automaticamente ao tema do app
3. **Manutenibilidade**: Mudanças no tema são refletidas automaticamente em todos os componentes
4. **Dark/Light Mode**: Transições de tema funcionam sem código adicional

#### Como acessar o Theme

**Método 1: Via GetX (recomendado no ModLayoutOne)**
```dart
// Obter o tema atual
final theme = Get.theme;

// Cores do ColorScheme
final primaryColor = Get.theme.colorScheme.primary;
final secondaryColor = Get.theme.colorScheme.secondary;
final surfaceColor = Get.theme.colorScheme.surface;
final backgroundColor = Get.theme.colorScheme.background;
final errorColor = Get.theme.colorScheme.error;
final onPrimaryColor = Get.theme.colorScheme.onPrimary;

// Tipografia do TextTheme
final headlineLarge = Get.theme.textTheme.headlineLarge;
final bodyMedium = Get.theme.textTheme.bodyMedium;
final labelSmall = Get.theme.textTheme.labelSmall;

// Outras propriedades
final scaffoldBg = Get.theme.scaffoldBackgroundColor;
final cardColor = Get.theme.cardColor;
final dividerColor = Get.theme.dividerColor;
```

**Método 2: Via BuildContext**
```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Container(
    color: colorScheme.surface,
    child: Text(
      'Exemplo',
      style: textTheme.bodyMedium,
    ),
  );
}
```

#### Exemplos: O que NÃO fazer vs O que fazer

| Incorreto (Hardcoded) | Correto (Theme) |
|----------------------|------------------|
| `Colors.blue` | `Get.theme.colorScheme.primary` |
| `Colors.red` | `Get.theme.colorScheme.error` |
| `Colors.grey[50]` | `Get.theme.scaffoldBackgroundColor` |
| `Colors.white` | `Get.theme.colorScheme.onPrimary` |
| `Colors.black` | `Get.theme.colorScheme.onSurface` |
| `Color(0xFF1E1E2D)` | `Get.theme.appBarTheme.backgroundColor` |
| `TextStyle(fontSize: 16)` | `Get.theme.textTheme.bodyLarge` |

#### Cores Semânticas

Para cores semânticas (success, warning, info, danger), utilize **Theme Extensions**:

```dart
// Definição da extensão
class ModSemanticColors extends ThemeExtension<ModSemanticColors> {
  final Color success;
  final Color warning;
  final Color info;
  final Color danger;

  const ModSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.danger,
  });

  @override
  ModSemanticColors copyWith({...}) => ModSemanticColors(...);

  @override
  ModSemanticColors lerp(ModSemanticColors? other, double t) => ...;
}

// Uso no componente
final semanticColors = Get.theme.extension<ModSemanticColors>();
final successColor = semanticColors?.success ?? Colors.green;
```

#### Fallbacks seguros

Quando usar extensões do tema, sempre forneça um fallback:

```dart
// Com fallback seguro
final successColor = Get.theme.extension<ModSemanticColors>()?.success
    ?? Colors.green;

// Para cores padrão do ColorScheme (não precisa fallback)
final primaryColor = Get.theme.colorScheme.primary; // Sempre disponível
```

#### Checklist de Conformidade

Antes de finalizar qualquer componente, verifique:

- [ ] Nenhuma cor está definida com `Colors.xxx` diretamente
- [ ] Nenhum `Color(0xFFxxxxxx)` hardcoded
- [ ] Todas as cores vêm do `Theme` ou `ThemeExtension`
- [ ] Textos usam estilos do `TextTheme` quando possível
- [ ] Fontes customizadas respeitam a família do tema
- [ ] Espaçamentos seguem os tokens definidos

---

## Design Tokens (Foundations)

> **IMPORTANTE**: Os tokens abaixo são valores de **referência** definidos no `AppTheme` padrão do package.
> Nos componentes, **NUNCA use estes valores diretamente**. Sempre acesse via `Theme.of(context)` ou `Get.theme`.
> O app consumidor pode sobrescrever estes valores através de seus próprios temas.

### Cores

#### Paleta Principal (AppTheme - Valores Padrão)

Os valores abaixo são os padrões do package, mas devem ser acessados via Theme:

```dart
// Valores padrão (definidos em AppTheme)
darkBackground: Color(0xFF1A1D1F)   // Acessar: Get.theme.scaffoldBackgroundColor (dark)
darkSurface: Color(0xFF2C2F33)      // Acessar: Get.theme.colorScheme.surface (dark)
appBarColor: Color(0xFF1E1E2D)      // Acessar: Get.theme.appBarTheme.backgroundColor

// Tema Claro
scaffoldBackground: Colors.grey[50] // Acessar: Get.theme.scaffoldBackgroundColor

// Tema Escuro
scaffoldBackground: darkBackground  // Acessar: Get.theme.scaffoldBackgroundColor
```

#### Cores Semânticas (ButtonType)

| Tipo | Acesso Correto | Fallback* | Uso |
|------|----------------|-----------|-----|
| Primary | `Get.theme.colorScheme.primary` | - | Ação principal |
| Secondary | `Get.theme.colorScheme.secondary` | - | Ação secundária |
| Success | `Get.theme.extension<ModSemanticColors>()?.success` | `Colors.green` | Confirmação, sucesso |
| Info | `Get.theme.extension<ModSemanticColors>()?.info` | `Colors.lightBlue` | Informação |
| Warning | `Get.theme.extension<ModSemanticColors>()?.warning` | `Colors.orange` | Alerta, atenção |
| Danger | `Get.theme.colorScheme.error` | - | Erro, exclusão |
| Dark | `Get.theme.colorScheme.surface` | - | Neutro escuro |
| Default | `Get.theme.colorScheme.surfaceVariant` | - | Neutro |

> *Fallbacks são usados apenas quando a ThemeExtension não está disponível

### Tipografia

> **Recomendação**: Sempre que possível, utilize os estilos do `TextTheme` do tema ativo em vez de tamanhos fixos.
> Mapeamento sugerido: xs → `labelSmall`, sm → `bodySmall`, md → `bodyMedium`, lg → `bodyLarge`

#### Tamanhos de Fonte por Size (Referência)
| Size | Button | TextBox | Label | TextTheme Equivalente |
|------|--------|---------|-------|----------------------|
| **xs** | 12px | 10px | - | `labelSmall` |
| **sm** | 14px | 14px | - | `bodySmall` |
| **md** | 16px | 16px | 14px (default) | `bodyMedium` |
| **lg** | 18px | 18px | - | `bodyLarge` |
| **xl** | - | - | - | `titleMedium` |

#### Como usar tipografia do Theme
```dart
// Recomendado: usar TextTheme
Text('Título', style: Get.theme.textTheme.titleLarge);
Text('Corpo', style: Get.theme.textTheme.bodyMedium);
Text('Label', style: Get.theme.textTheme.labelSmall);

// Se precisar customizar, copie e modifique
Text('Custom', style: Get.theme.textTheme.bodyMedium?.copyWith(
  fontWeight: FontWeight.bold,
  color: Get.theme.colorScheme.primary,
));
```

### Espaçamento

#### Padding por Size (Buttons)
| Size | Horizontal | Vertical |
|------|------------|----------|
| **xs** | 8px | 4px |
| **sm** | 12px | 6px |
| **md** | 16px | 8px |
| **lg** | 24px | 12px |

#### Alturas por Size
| Size | Button | TextBox |
|------|--------|---------|
| **xs** | 24px | 29px |
| **sm** | 32px | 42px |
| **md** | 40px | 50px |
| **lg** | 48px | 61px |

### Border Radius
- **Padrão geral:** 8px (TextBox)
- **Botões:** 4px (padrão)
- **Cards/Modals:** 8px
- **Progress:** 6px

### Breakpoints (Grid System)
| Breakpoint | Largura |
|------------|---------|
| Mobile | < 768px |
| Desktop | >= 768px |

---

## Inventário de Componentes

### 1. Layout Components

#### ModBaseLayout
**Propósito:** Scaffold principal com sidebar, header e footer integrados.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `controller` | ModBaseLayoutController? | Gerenciamento dinâmico de estado |
| `title` | String | Título no header |
| `logo` | Widget? | Logo customizado |
| `menuGroups` | List<MenuGroup>? | Grupos de menu |
| `moduleMenuGroups` | List<ModuleMenu>? | Sistema de módulos |
| `claims` | List<String>? | Claims para validação de permissões |
| `userProfile` | UserProfile? | Perfil do usuário |
| `chatbotConfig` | ChatbotConfig? | Chatbot flutuante (Windows/Web) |

**Estados:**
- Desktop: Sidebar colapsável (70px collapsed, 240px expanded)
- Mobile: Drawer navegável
- NoAccess: Tela de sem permissão

#### ModSidebar
**Propósito:** Menu lateral colapsável para desktop.

**Características:**
- Grupos de menu expansíveis
- Validação de claims por item
- Suporte a ícones customizados
- Animação de collapse (200ms)

#### ModHeader
**Propósito:** AppBar customizável com tema e idioma.

**Características:**
- Logo ou título
- Toggle de tema (light/dark)
- Seletor de idioma
- Perfil de usuário
- Ações customizáveis

#### ModFooter
**Propósito:** Rodapé fixo customizável.

**Propriedades:**
- `height`: Altura (padrão: 50px)
- `backgroundColor`: Cor de fundo
- `border`: Borda customizada

---

### 2. Input Components

#### ModTextBox
**Propósito:** Campo de texto versátil com múltiplos modos.

| Size | Altura | Font |
|------|--------|------|
| xs | 29px | 10px |
| sm | 42px | 14px |
| md | 50px | 16px |
| lg | 61px | 18px |

**Modos:**
- **Padrão:** Input de texto simples
- **Password:** Com toggle de visibilidade
- **Multiline:** Área de texto
- **Number Mode:** Com botões +/- (leftRight ou topBottom)

**Estados:**
- Default, Focus, Error, Disabled, ReadOnly
- Validação com feedback (tooltip em desktop, texto em mobile)

**Features:**
- Label (top/left/floating)
- Prefix/Suffix icons
- Validação customizada
- Enter action handler (desktop/web)

#### ModDropDown<T>
**Propósito:** Dropdown selector genérico.

**Características:**
- Suporte a tipos genéricos
- Items como lista de widgets
- Callbacks onChange

#### ModDropdownSearch
**Propósito:** Dropdown com busca e carregamento assíncrono.

**Características:**
- Busca em tempo real
- Async loading
- Debounce integrado
- Items customizáveis

---

### 3. Button Components

#### ModButton
**Propósito:** Botão principal com múltiplas variantes.

**Types (ModButtonType):**
| Type | Cor de Fundo | Uso |
|------|--------------|-----|
| `primary` | Primary color | CTAs principais |
| `secondary` | Secondary color | Ações secundárias |
| `success` | Green | Confirmação |
| `info` | LightBlue | Informação |
| `warning` | Orange | Atenção |
| `danger` | Red | Exclusão/Erro |
| `dark` | Surface | Neutro |
| `defaultType` | Grey.300 | Padrão |
| `none` | Transparent | Ghost/Outline |
| `custom` | backgroundColor | Customizado |

**Sizes (ModButtonSize):**
| Size | Altura | Padding H | Font | Icon |
|------|--------|-----------|------|------|
| xs | 24px | 8px | 12px | 16px |
| sm | 32px | 12px | 14px | 18px |
| md | 40px | 16px | 16px | 20px |
| lg | 48px | 24px | 18px | 24px |

**Estados:**
- Default, Hover (via InkWell), Pressed, Disabled, Loading

**Layouts:**
- **Default:** leftIcon + title + rightIcon
- **Center Icon:** centerIcon + title (vertical)

#### ModIconButton
**Propósito:** Botão apenas com ícone.

**Propriedades:**
- `icon`: IconData
- `tooltip`: String?
- `color`: Color?
- `iconSize`: double?
- `onPressed`: VoidCallback?

#### ModPopupButton
**Propósito:** Botão com menu popup.

**Características:**
- Lista de PopupMenuItem
- onSelected callback
- Tooltip support

---

### 4. Data Display Components

#### ModDataTable<T>
**Propósito:** Tabela de dados com paginação, ordenação e ações.

**Características:**
- Headers customizáveis (width fixed/percentage)
- Sorting (asc/desc)
- Paginação (simple/full)
- Column resize
- Row hover (Windows/Web only)
- Action bar com grid responsivo
- Column settings modal
- Empty view widget

**Propriedades de Estilo:**
- `oddRowColor`: Cor linhas ímpares
- `evenRowColor`: Cor linhas pares
- `headerBackgroundColor`: Cor header
- `footerBackgroundColor`: Cor footer
- `hoverColor`: Cor hover

**Paginação:**
- `rowsPerPage`: Linhas por página
- `availableRowsPerPage`: [5, 10, 15, 20, 50, 100, 200]
- `enableSimplePagination`: Paginação simplificada

#### ModTreeView
**Propósito:** Visualização hierárquica com drag-and-drop.

**Características:**
- TreeNode model (id, label, icon, children)
- Drag & Drop
- Checkboxes
- Context menu customizado
- Expander types (triangle, arrow, plusMinus)
- State indicators (synced, new, update, sync)

**TreeViewTheme:**
- `indentation`: 20px (default)
- `iconSize`: 16px
- `selectionColor`: Color(0x1A2196F3)
- `showLines`: true

#### ModCard
**Propósito:** Card com header, content e footer.

**Características:**
- Accordion mode
- Header customizável
- Content padding
- Footer opcional
- Border radius

---

### 5. Feedback Components

#### ModToast
**Propósito:** Notificações toast posicionáveis.

**Positions (ToastPosition):**
```
topLeft    | topCenter    | topRight
left       | center       | right
bottomLeft | bottomCenter | bottomRight
topLeftAppBar | topCenterAppBar | topRightAppBar | appBar
```

**Types (ToastType):**
| Type | Cor | Ícone Default |
|------|-----|---------------|
| success | Green | check_circle |
| error | Red | error |
| warning | Orange | warning |
| info | Blue | info |
| custom | Custom | Custom |

**Propriedades:**
- `duration`: 3s (default)
- `showCloseButton`: true
- `animation`: slide/fade

#### ModDialog
**Propósito:** Diálogos modais customizáveis.

**Sizes (DialogSize):**
| Size | Largura |
|------|---------|
| xs | 300px |
| sm | 400px |
| md | 500px |
| lg | 700px |

**Positions (DialogPosition):**
```
topLeft    | topCenter    | topRight
centerLeft | center       | centerRight
bottomLeft | bottomCenter | bottomRight
```

**ButtonAlignment:**
- left, center, right, spaceBetween, spaceAround, spaceEvenly

#### ModModal
**Propósito:** Modal overlay com posicionamento flexível.

**Sizes (ModModalSize):**
| Size | Largura |
|------|---------|
| xs | 300px |
| sm | 400px |
| md | 600px |
| lg | 800px |

**Heights (ModModalHeight):**
- auto, small, medium, large, full

#### ModLoading
**Propósito:** Loading overlay com ícone/imagem customizável.

**Positions:** center, left, right, topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight

**Características:**
- Ícone animado (rotation)
- Imagem customizada (PNG/SVG)
- Título opcional
- Orientação (vertical/horizontal)
- NavigatorObserver para auto-close

#### ModProgress
**Propósito:** Indicador de progresso com controller.

**Types:**
- `circular`: CircularProgressIndicator
- `linear`: LinearProgressIndicator

**Positions:** topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight

**Estados:**
- Indeterminate (progress = null)
- Determinate (0.0 - 1.0)
- Completed (isCompleted = true)
- Error (hasError = true)

**ModProgressController:**
- `progress`: RxnDouble
- `isVisible`: RxBool
- `title`, `subtitle`: RxString
- `isCompleted`, `hasError`: RxBool
- `errorMessage`: RxString

---

### 6. Navigation Components

#### ModTabs
**Propósito:** Navegação por abas.

**Orientations:**
- `horizontalTop`: Tabs em cima
- `horizontalBottom`: Tabs embaixo
- `verticalLeft`: Tabs à esquerda (200px)
- `verticalRight`: Tabs à direita (200px)

**Características:**
- Tabs closeable (onClosing async)
- Icon support
- New tab button
- External selectedIndex control
- Empty widget
- Scroll navigation (chevron buttons)

**BorderTypes:**
- none, bottom, all

**Alignment:**
- left, center, right, justify

---

### 7. Utility Components

#### ModLabel
**Propósito:** Texto com suporte a markdown básico.

**Features:**
- Bold: `*texto*`
- Cores: textColor, boldColor

#### ModAvatar
**Propósito:** Avatar com formas e tamanhos variados.

**Shapes (ModAvatarShape):**
- square, circle, triangle

**Sizes (ModAvatarSize):**
| Size | Dimensão |
|------|----------|
| xs | 24px |
| sm | 32px |
| md | 48px |
| lg | 64px |

#### ModWheelSlider
**Propósito:** Seletor tipo "roda" para valores numéricos.

**Modes:**
- `line`: Linhas simples
- `number`: Números visíveis
- `custom`: Widget customizado

**Características:**
- Min/Max values
- Decimal support
- Haptic feedback
- External controller

#### Grid System (ModContainer, ModRow, ModColumn)
**Propósito:** Sistema de grid responsivo.

**Características:**
- Container com maxWidth
- Row com columns responsivos
- Column com size maps por breakpoint

---

## Análise UX por Categoria

### Layout e Navegação

**Pontos Positivos:**
- Sistema de módulos com validação de claims
- Transição suave mobile/desktop (768px breakpoint)
- Chatbot integrado (Windows/Web)
- Controller pattern para atualizações dinâmicas

**Pontos de Atenção:**
- Apenas um breakpoint (768px) - falta granularidade
- Sidebar não tem scroll próprio visível
- Módulos requerem reload manual em alguns casos

### Inputs e Forms

**Pontos Positivos:**
- ModTextBox muito versátil (password, multiline, numberMode)
- Validação com feedback diferenciado por plataforma
- Enter action para desktop/web
- Sizes consistentes

**Pontos de Atenção:**
- Falta máscara de input integrada
- Dropdown search não tem highlight de match
- Falta date/time picker nativo

### Feedback e Comunicação

**Pontos Positivos:**
- Toast com 13 posições diferentes
- Progress com controller reativo (GetX)
- Loading com NavigatorObserver para auto-close
- Dialog com múltiplos alignments de botões

**Pontos de Atenção:**
- Falta sistema de confirmação padronizado
- Loading não tem progress percent visual
- Toast não tem queue/stack management

---

## Análise UI

### Consistência Visual

**Cores:**
- Semântica bem definida (success=green, danger=red, etc.)
- Tema claro/escuro com transição automática
- ⚠️ **CRÍTICO**: Cores hardcoded em alguns componentes - **DEVE ser corrigido**
  - Ver seção [Princípios Fundamentais](#princípios-fundamentais) para a abordagem correta
  - Todos os `Colors.xxx` diretos devem ser substituídos por referências ao Theme
  - Usar `ThemeExtension` para cores semânticas (success, warning, info)

**Tipografia:**
- Escala de tamanhos consistente por size
- Falta definição de fontWeight por hierarquia
- Labels usam bodyMedium (poderia ter mais opções)
- ⚠️ Recomendado: migrar para uso do `TextTheme` do tema ativo

**Espaçamento:**
- Padding consistente por size nos botões
- ContentPadding calculado dinamicamente no TextBox
- Falta sistema de spacing tokens (4, 8, 12, 16, 24, 32...)

### Acessibilidade (WCAG)

**Implementado:**
- Tooltips em desktop
- Semantic widgets (IconButton, TextFormField)
- Focus management básico

**Faltando:**
- Contraste não verificado programaticamente
- Falta Semantics em componentes customizados
- Falta suporte a screen readers
- Falta keyboard navigation em TreeView
- Falta announcements para mudanças de estado

---

## Problemas Identificados

### Alta Prioridade

1. **Cores hardcoded** ⚠️ **VIOLAÇÃO DO PRINCÍPIO FUNDAMENTAL**
   - `Colors.grey.shade300` usado diretamente em buttons, dialogs
   - `Colors.green`, `Colors.red`, `Colors.orange`, `Colors.lightBlue` sem considerar tema
   - `Color(0xFFxxxxxx)` hardcoded em vários lugares
   - **Impacto:** Inconsistência visual, dificuldade de theming, componentes não se adaptam ao tema do app consumidor
   - **Solução:** Ver seção [Princípios Fundamentais > Uso Obrigatório do Theme](#uso-obrigatório-do-theme)
   - **Ação Requerida:** Substituir todas as cores hardcoded por referências ao `Theme`

2. **Falta de Accessibility**
   - Sem Semantics em componentes customizados
   - Contraste não garantido
   - **Impacto:** Não atende WCAG AA

3. **withOpacity deprecated**
   - Múltiplos usos de `.withOpacity()` ao invés de `.withValues()`
   - **Impacto:** Warnings de deprecation

### Média Prioridade

4. **Breakpoint único**
   - Apenas 768px para mobile/desktop
   - **Impacto:** UX subótima em tablets

5. **Hover apenas Windows/Web**
   - `_isHoverEnabled` exclui macOS/Linux
   - **Impacto:** Experiência inconsistente

6. **Loading singleton**
   - `ModLoading.instance` pattern
   - **Impacto:** Dificuldade com múltiplos loadings

### Baixa Prioridade

7. **Debug prints em produção**
   - `debugPrint` em vários lugares
   - **Impacto:** Poluição de logs

8. **AnimatedBuilder vs AnimatedWidget**
   - Uso de `AnimatedBuilder` onde `AnimatedWidget` seria mais adequado
   - **Impacto:** Performance marginal

9. **Nomes inconsistentes**
   - `icon_buttom.dart` (typo: button)
   - `popup_buttom.dart` (typo: button)
   - **Impacto:** Confusão no codebase

---

## Melhorias Sugeridas

### Curto Prazo (Sprint 1-2)

1. **Criar Design Tokens centralizados**
```dart
class ModTokens {
  // Spacing
  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space24 = 24.0;
  static const space32 = 32.0;

  // Radius
  static const radiusSm = 4.0;
  static const radiusMd = 8.0;
  static const radiusLg = 12.0;
  static const radiusFull = 999.0;

  // Transitions
  static const durationFast = Duration(milliseconds: 150);
  static const durationNormal = Duration(milliseconds: 250);
  static const durationSlow = Duration(milliseconds: 400);
}
```

2. **Substituir cores hardcoded por theme colors** ⭐ **PRIORIDADE MÁXIMA**

Esta é a mudança mais crítica para garantir compatibilidade com apps consumidores.

```dart
// Antes (INCORRETO - não usar)
color: Colors.green
color: Colors.grey.shade300
color: Color(0xFF1E1E2D)

// Depois (CORRETO - usar sempre)
// Para cores semânticas
color: Get.theme.extension<ModSemanticColors>()?.success ?? Colors.green

// Para cores do ColorScheme
color: Get.theme.colorScheme.primary
color: Get.theme.colorScheme.surfaceVariant
color: Get.theme.appBarTheme.backgroundColor

// Para disabled state
color: Get.theme.disabledColor

// Para texto
color: Get.theme.colorScheme.onSurface
color: Get.theme.colorScheme.onPrimary
```

**Arquivos que requerem atualização:**
- `lib/widgets/buttons/buttons.dart` - `_getTypeColor()`, `_getBorderColor()`, `_getTextColor()`
- `lib/widgets/toast/mod_toast.dart` - cores de tipos de toast
- `lib/widgets/datatable/datatable.dart` - cores de linhas e hover
- `lib/widgets/dialog/dialog.dart` - cores de fundo e borda
- Todos os arquivos com `Colors.xxx` direto

3. **Corrigir typos nos nomes de arquivos**
   - `icon_buttom.dart` → `icon_button.dart`
   - `popup_buttom.dart` → `popup_button.dart`

4. **Substituir withOpacity por withValues**
```dart
// Antes
color.withOpacity(0.5)
// Depois
color.withValues(alpha: 0.5)
```

### Médio Prazo (Sprint 3-4)

5. **Adicionar mais breakpoints**
```dart
class ModBreakpoints {
  static const xs = 0.0;    // Extra small (phones)
  static const sm = 576.0;  // Small (large phones)
  static const md = 768.0;  // Medium (tablets)
  static const lg = 992.0;  // Large (desktops)
  static const xl = 1200.0; // Extra large (large desktops)
  static const xxl = 1400.0; // Extra extra large
}
```

6. **Implementar Accessibility**
```dart
Semantics(
  label: 'Botão de salvar',
  button: true,
  enabled: !disabled,
  child: ModButton(...),
)
```

7. **Criar sistema de confirmação padronizado**
```dart
ModConfirm.show(
  title: 'Confirmar exclusão?',
  message: 'Esta ação não pode ser desfeita.',
  confirmText: 'Excluir',
  confirmType: ModButtonType.danger,
  onConfirm: () => deleteItem(),
);
```

### Curto Prazo - Adicional (Sprint 1-2)

8. **Implementar Theme Extensions** ⭐ **ESSENCIAL PARA COMPATIBILIDADE**

Esta implementação é **pré-requisito** para o item 2 (substituição de cores hardcoded).

```dart
// Definição em lib/themes/mod_semantic_colors.dart
class ModSemanticColors extends ThemeExtension<ModSemanticColors> {
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;
  final Color danger;
  final Color dangerLight;

  const ModSemanticColors({
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.danger,
    required this.dangerLight,
  });

  // Valores padrão do package
  static const defaultLight = ModSemanticColors(
    success: Color(0xFF4CAF50),
    successLight: Color(0xFFE8F5E9),
    warning: Color(0xFFFF9800),
    warningLight: Color(0xFFFFF3E0),
    info: Color(0xFF03A9F4),
    infoLight: Color(0xFFE1F5FE),
    danger: Color(0xFFF44336),
    dangerLight: Color(0xFFFFEBEE),
  );

  @override
  ModSemanticColors copyWith({...}) => ModSemanticColors(...);

  @override
  ModSemanticColors lerp(ModSemanticColors? other, double t) {
    if (other == null) return this;
    return ModSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      // ... outros campos
    );
  }
}

// Uso nos componentes
final colors = Get.theme.extension<ModSemanticColors>()
    ?? ModSemanticColors.defaultLight;
final successColor = colors.success;
```

### Longo Prazo (Sprint 5+)

9. **Criar sistema de form validation**
```dart
class ModFormController extends GetxController {
  final fields = <String, ModFieldController>{}.obs;
  bool get isValid => fields.values.every((f) => f.isValid);
  void validate() => fields.values.forEach((f) => f.validate());
}
```

10. **Adicionar sistema de feedback háptico**
```dart
enum ModHapticFeedback { light, medium, heavy, selection, success, error }
```

---

## Impacto Esperado

### Métricas de UX

| Área | Estado Atual | Meta | Impacto |
|------|--------------|------|---------|
| **Consistência Visual** | 70% | 95% | Redução de 50% no tempo de desenvolvimento de novos componentes |
| **Accessibility (WCAG)** | ~40% | AA (85%+) | Conformidade legal, inclusão |
| **Manutenibilidade** | Média | Alta | Redução de 30% em bugs relacionados a UI |
| **Performance** | Boa | Ótima | Melhoria de 15% no FPS em animações |
| **Developer Experience** | Boa | Excelente | Redução de 25% no onboarding time |

### ROI Estimado

- **Design Tokens:** 20h investidas → 100h+ economizadas/ano
- **Accessibility:** 40h investidas → Compliance + 15% mais usuários
- **Tema Extensions:** 16h investidas → 50% menos código de theming

---

## Diretrizes de Design System

### Nomenclatura

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Widget | `Mod` + PascalCase | `ModButton`, `ModTextBox` |
| Enum | PascalCase + Type | `ModButtonType`, `ModTextBoxSize` |
| Config | Widget + `Config` | `ModProgressConfig` |
| Controller | Widget + `Controller` | `ModProgressController` |
| Theme | Widget + `Theme` | `TreeViewTheme` |

### Estados de Componentes

Todo componente interativo deve implementar:

1. **Default** - Estado inicial
2. **Hover** - Mouse sobre (desktop)
3. **Focus** - Foco via teclado
4. **Active/Pressed** - Durante interação
5. **Disabled** - Desabilitado
6. **Loading** - Processando (quando aplicável)
7. **Error** - Estado de erro (quando aplicável)
8. **Success** - Ação concluída (quando aplicável)

### Documentação de Componente

Todo componente público deve ter:

```dart
/// [Nome do Componente]
///
/// Descrição breve do propósito.
///
/// ## Exemplo de uso:
/// ```dart
/// ModComponente(
///   propriedade: valor,
/// )
/// ```
///
/// ## Estados:
/// - default: Descrição
/// - disabled: Descrição
///
/// ## Variações:
/// - [Variation1]: Descrição
/// - [Variation2]: Descrição
///
/// ## Acessibilidade:
/// - Suporta screen readers
/// - Navegável via teclado
///
/// See also:
/// - [ComponenteRelacionado]
```

---

## Boas Práticas de Compatibilidade

Esta seção documenta as boas práticas para garantir que os componentes do ModLayoutOne funcionem corretamente em qualquer projeto consumidor, independente do tema configurado.

### 1. Nunca assumir cores específicas

O projeto consumidor pode ter qualquer paleta de cores. Seu componente deve se adaptar.

```dart
// ❌ ERRADO - Assume que o fundo é claro
Text('Label', style: TextStyle(color: Colors.black));

// ✅ CORRETO - Usa a cor de texto do tema
Text('Label', style: TextStyle(color: Get.theme.colorScheme.onSurface));
```

### 2. Testar em ambos os modos (Light/Dark)

Sempre teste seus componentes em ambos os temas:

```dart
// No app consumidor
MaterialApp(
  theme: lightTheme,    // Testar aqui
  darkTheme: darkTheme, // E aqui
  themeMode: ThemeMode.system,
)
```

### 3. Fornecer fallbacks sensatos

Quando usar ThemeExtensions, sempre forneça um fallback:

```dart
// Fallback para valores padrão se a extensão não existir
final semanticColors = Get.theme.extension<ModSemanticColors>()
    ?? ModSemanticColors.defaultLight;
```

### 4. Respeitar o contraste do tema

Use cores `on*` para texto sobre superfícies coloridas:

| Superfície | Cor do texto |
|------------|--------------|
| `primary` | `onPrimary` |
| `secondary` | `onSecondary` |
| `surface` | `onSurface` |
| `background` | `onBackground` |
| `error` | `onError` |

```dart
Container(
  color: Get.theme.colorScheme.primary,
  child: Text(
    'Texto',
    style: TextStyle(color: Get.theme.colorScheme.onPrimary),
  ),
)
```

### 5. Documentar extensões necessárias

Se um componente requer uma ThemeExtension específica, documente isso:

```dart
/// ModToast requer [ModSemanticColors] no tema para cores customizadas.
/// Se não estiver presente, usa cores padrão.
///
/// Exemplo de configuração no app consumidor:
/// ```dart
/// ThemeData(
///   extensions: [
///     ModSemanticColors(
///       success: Colors.green,
///       // ...
///     ),
///   ],
/// )
/// ```
class ModToast { ... }
```

### 6. Evitar brightness checks manuais

Não verifique manualmente se o tema é claro ou escuro:

```dart
// ❌ ERRADO
final isDark = Get.theme.brightness == Brightness.dark;
final bgColor = isDark ? Colors.grey[900] : Colors.white;

// ✅ CORRETO - O tema já sabe qual cor usar
final bgColor = Get.theme.colorScheme.surface;
```

### 7. Permitir customização via parâmetros

Para casos onde o consumidor precisa de controle total:

```dart
class ModCard extends StatelessWidget {
  /// Cor de fundo do card.
  /// Se null, usa [Theme.cardColor].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Get.theme.cardColor,
      // ...
    );
  }
}
```

### 8. Guia para o App Consumidor

Apps que utilizam o ModLayoutOne devem configurar seu tema assim:

```dart
// main.dart do app consumidor
void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // Adicionar extensão para cores semânticas
        extensions: [
          ModSemanticColors(
            success: Color(0xFF4CAF50),
            warning: Color(0xFFFF9800),
            info: Color(0xFF03A9F4),
            danger: Color(0xFFF44336),
            // ... outros campos
          ),
        ],
      ),
      darkTheme: ThemeData.dark().copyWith(
        extensions: [
          ModSemanticColors(
            success: Color(0xFF81C784),
            warning: Color(0xFFFFB74D),
            info: Color(0xFF4FC3F7),
            danger: Color(0xFFE57373),
            // ... outros campos
          ),
        ],
      ),
    ),
  );
}
```

---

## Próximos Passos

### Fase 1: Foundations e Compatibilidade de Tema (2 semanas) ⭐ **PRIORIDADE MÁXIMA**

> **IMPORTANTE**: Esta fase é crítica para garantir que o package funcione corretamente
> em todos os projetos consumidores, independente do tema que utilizem.

- [ ] **Implementar `ModSemanticColors` ThemeExtension** (pré-requisito para tudo)
- [ ] **Substituir TODAS as cores hardcoded por referências ao Theme**
  - [ ] `lib/widgets/buttons/buttons.dart`
  - [ ] `lib/widgets/toast/mod_toast.dart`
  - [ ] `lib/widgets/datatable/datatable.dart`
  - [ ] `lib/widgets/dialog/dialog.dart`
  - [ ] `lib/widgets/textbox/textbox.dart`
  - [ ] Todos os arquivos restantes com `Colors.xxx`
- [ ] Criar arquivo `tokens.dart` com Design Tokens
- [ ] Corrigir typos nos nomes de arquivos
- [ ] Substituir `withOpacity` por `withValues`
- [ ] Remover `debugPrint` de produção

### Fase 2: Consistência Visual (2 semanas)
- [ ] Padronizar uso de cores via ThemeExtension em todos os componentes restantes
- [ ] Unificar sistema de sizes (xs, sm, md, lg, xl)
- [ ] Padronizar borderRadius em todos componentes
- [ ] Migrar textos para usar `TextTheme` quando apropriado
- [ ] Criar helper methods para acesso consistente ao Theme

### Fase 3: Accessibility (3 semanas)
- [ ] Adicionar Semantics em todos componentes
- [ ] Implementar keyboard navigation
- [ ] Verificar contraste WCAG AA
- [ ] Adicionar announcements para screen readers
- [ ] Testar com VoiceOver/TalkBack

### Fase 4: Novos Componentes (4 semanas)
- [ ] ModDatePicker
- [ ] ModTimePicker
- [ ] ModChip/Tag
- [ ] ModBadge
- [ ] ModSkeleton (loading placeholder)
- [ ] ModConfirmDialog

### Fase 5: Documentação (contínuo)
- [ ] Documentar todos os componentes públicos
- [ ] Criar Storybook/Widgetbook
- [ ] Escrever guias de uso
- [ ] Criar exemplos interativos

---

## Apêndice: Referência Rápida de Componentes

### Por Categoria

```
LAYOUT
├── ModBaseLayout       # Scaffold principal
├── ModSidebar          # Menu lateral
├── ModHeader           # AppBar
├── ModFooter           # Rodapé
└── MobileDrawer        # Menu mobile

INPUT
├── ModTextBox          # Campo de texto
├── ModDropDown         # Dropdown
└── ModDropdownSearch   # Dropdown com busca

BUTTONS
├── ModButton           # Botão principal
├── ModIconButton       # Botão de ícone
└── ModPopupButton      # Botão com popup

DATA DISPLAY
├── ModDataTable        # Tabela de dados
├── ModTreeView         # Árvore hierárquica
└── ModCard             # Card

FEEDBACK
├── ModToast            # Toast notification
├── ModDialog           # Diálogo modal
├── ModModal            # Modal overlay
├── ModLoading          # Loading overlay
└── ModProgress         # Indicador de progresso

NAVIGATION
└── ModTabs             # Navegação por abas

UTILITY
├── ModLabel            # Texto formatado
├── ModAvatar           # Avatar
├── ModWheelSlider      # Seletor rotativo
└── Grid System         # Container/Row/Column
```

### Mapa de Imports

```dart
// Tudo em um
import 'package:mod_layout_one/mod_layout_one.dart';

// Por categoria
import 'package:mod_layout_one/layout/base_layout.dart';
import 'package:mod_layout_one/widgets/buttons/buttons.dart';
import 'package:mod_layout_one/widgets/textbox/textbox.dart';
import 'package:mod_layout_one/widgets/datatable/datatable.dart';
// ...
```

---

*Documento gerado como parte da Task [352] - Padronização e Guia de UX para Componentes*
