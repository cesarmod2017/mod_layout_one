# Guia de Personalização - Mod Layout One

Este guia demonstra como utilizar os novos parâmetros opcionais para personalizar a aparência dos componentes de menu.

## Novos Parâmetros Disponíveis

### ModuleMenu

O `ModuleMenu` agora suporta os seguintes parâmetros opcionais:
- `fontSize`: Tamanho da fonte do texto do módulo
- `fontWeight`: Peso da fonte do texto do módulo
- `iconSize`: Tamanho do ícone do módulo

```dart
ModuleMenu(
  name: 'Documentos',
  icon: Icons.description,
  description: 'Gestão de documentos',
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  iconSize: 28.0,
  menuGroups: [
    // ...
  ],
)
```

### MenuGroup

O `MenuGroup` agora suporta os seguintes parâmetros opcionais:
- `fontSize`: Tamanho da fonte dos itens do grupo
- `fontWeight`: Peso da fonte dos itens do grupo
- `iconSize`: Tamanho dos ícones dos itens do grupo

```dart
MenuGroup(
  title: Text('Components'),
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  iconSize: 22.0,
  items: [
    // ...
  ],
)
```

### MenuItem

O `MenuItem` agora suporta os seguintes parâmetros opcionais:
- `fontSize`: Tamanho da fonte do item de menu
- `fontWeight`: Peso da fonte do item de menu
- `iconSize`: Tamanho do ícone do item de menu

```dart
MenuItem(
  title: 'Corporate',
  icon: Icons.business,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  iconSize: 20.0,
  route: '/corporate',
  subItems: [
    MenuItem(
      title: 'Avatars',
      icon: Icons.telegram,
      fontSize: 12.0,
      iconSize: 18.0,
      route: '/avatars',
    ),
  ],
)
```

### ModBaseLayout - Drawer Background

O `ModBaseLayout` agora suporta um novo parâmetro opcional:
- `drawerBackgroundColor`: Cor de fundo específica para o drawer mobile

```dart
ModBaseLayout(
  title: 'Meu App',
  body: MyHomeWidget(),
  drawerBackgroundColor: Colors.red, // Aplicado diretamente ao Drawer widget
  // outros parâmetros...
)
```

**Nota**: O `drawerBackgroundColor` é aplicado diretamente ao widget `Drawer` do Flutter, garantindo que a cor seja exibida corretamente independente do tema atual.

## Hierarquia de Prioridade

Os parâmetros seguem uma hierarquia de prioridade:

1. **MenuItem** (maior prioridade)
2. **MenuGroup** (prioridade média)
3. **ModSidebar/MobileDrawer** (menor prioridade - valores padrão globais)

### Exemplo de Hierarquia

```dart
ModSidebar(
  fontSize: 16.0,        // Valor padrão para todos os itens
  fontWeight: FontWeight.normal,
  iconSize: 24.0,
  menuGroups: [
    MenuGroup(
      title: Text('Grupo 1'),
      fontSize: 14.0,      // Sobrescreve o valor do ModSidebar para este grupo
      items: [
        MenuItem(
          title: 'Item 1',
          icon: Icons.home,
          fontSize: 12.0,    // Sobrescreve os valores anteriores para este item específico
        ),
        MenuItem(
          title: 'Item 2',
          icon: Icons.settings,
          // Usa fontSize: 14.0 do MenuGroup
        ),
      ],
    ),
  ],
)
```

## Casos de Uso Comuns

### 1. Módulos com Diferentes Tamanhos

```dart
// Módulo principal com texto maior
ModuleMenu(
  name: 'Dashboard',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  iconSize: 32.0,
  // ...
),

// Módulo secundário com texto menor
ModuleMenu(
  name: 'Configurações',
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  iconSize: 24.0,
  // ...
),
```

### 2. Grupos com Estilos Diferentes

```dart
MenuGroup(
  title: Text('Navegação Principal'),
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  iconSize: 24.0,
  items: [
    // itens principais...
  ],
),
MenuGroup(
  title: Text('Ferramentas'),
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  iconSize: 18.0,
  items: [
    // ferramentas menores...
  ],
),
```

### 3. Itens Especiais com Destaque

```dart
MenuItem(
  title: 'Dashboard',
  icon: Icons.dashboard,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  iconSize: 28.0,
  route: '/dashboard',
),
MenuItem(
  title: 'Relatórios',
  icon: Icons.assessment,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  iconSize: 22.0,
  route: '/reports',
),
```

### 4. Drawer Personalizado

```dart
ModBaseLayout(
  title: 'Minha Aplicação',
  body: HomePage(),
  // Cor de fundo específica para o drawer mobile
  drawerBackgroundColor: Colors.blue[50],
  // Mantém as cores da sidebar desktop inalteradas
  sidebarBackgroundColor: Colors.white,
  // ...
)
```

## Compatibilidade

Todos os novos parâmetros são **opcionais** e não quebram a compatibilidade com o código existente. Se não especificados, os componentes usarão os valores padrão do tema atual.

## Notas Importantes

- Os valores `null` fazem com que o componente use o valor padrão da hierarquia
- Os parâmetros de estilo são aplicados tanto no desktop quanto no mobile
- O `drawerBackgroundColor` afeta apenas o drawer mobile, não a sidebar desktop
- Para melhor acessibilidade, evite tamanhos de fonte muito pequenos (< 12.0)
