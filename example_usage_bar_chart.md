# ModBarChart - Exemplo de Uso Atualizado

## Recursos Adicionados

### 1. Alinhamento de Título
```dart
ModBarChart(
  title: 'Vendas por Mês',
  titleAlign: TextAlign.left, // left (padrão), center, right
  // Fonte padrão agora é 16px
)
```

### 2. Background Personalizado
```dart
ModBarChart(
  // Transparente por padrão (respeita o tema)
  backgroundColor: Colors.white, // Opcional: cor de fundo
  containerBackgroundColor: Colors.grey[100], // Opcional: cor do container
)
```

### 3. Ícones de Zoom Customizáveis
```dart
ModBarChart(
  enableZoom: true,
  zoomInIcon: Icons.zoom_in,      // Opcional
  zoomOutIcon: Icons.zoom_out,    // Opcional  
  zoomResetIcon: Icons.refresh,   // Opcional
  // Agora são apenas ícones, sem botões
)
```

### 4. Tema de Botões de Ação
```dart
ModBarChart(
  actionButtonTheme: ChartActionButtonTheme(
    height: 40,        // Opcional: altura mínima (se não definir, ajusta pelo padding)
    fontSize: 12,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Ajusta tamanho automaticamente
    borderRadius: 15,
    borderWidth: 2,
    // Cores para tema claro
    lightSelectedBackgroundColor: Colors.blue,
    lightUnselectedBackgroundColor: Colors.grey[200],
    lightSelectedTextColor: Colors.white,
    lightUnselectedTextColor: Colors.black,
    lightBorderColor: Colors.blue,
    // Cores para tema escuro
    darkSelectedBackgroundColor: Colors.blueAccent,
    darkUnselectedBackgroundColor: Colors.grey[800],
    darkSelectedTextColor: Colors.white,
    darkUnselectedTextColor: Colors.grey[300],
    darkBorderColor: Colors.blueAccent,
  ),
)
```

### 5. Personalização da Legenda do Footer
```dart
ModBarChart(
  enableFooter: true,          // ✅ NECESSÁRIO para mostrar a legenda
  showLegendBorder: false,     // Remove bordas da legenda do footer
  showLegendContainer: false,  // Remove container da legenda do footer
  
  // IMPORTANTE: Essas opções afetam APENAS a legenda interativa do footer,
  // NÃO os botões de ação (ChartActionButton)
)
```

### 🎨 Exemplos da Legenda do Footer

```dart
// ✅ LEGENDA COMPLETA - Container com fundo e borda
ModBarChart(
  enableFooter: true,          // Ativa legenda interativa
  showLegendContainer: true,   // Container com fundo
  showLegendBorder: true,      // Com borda
  // Resultado: legenda em container estilizado + badges com borda
)

// ✅ LEGENDA SEM BORDA - Container transparente
ModBarChart(
  enableFooter: true,          // Ativa legenda interativa  
  showLegendContainer: true,   // Container ativo
  showLegendBorder: false,     // Sem borda, fundo transparente
  // Resultado: legenda sem container + badges sem borda
)

// ✅ LEGENDA MINIMALISTA - Sem decoração
ModBarChart(
  enableFooter: true,          // Ativa legenda interativa
  showLegendContainer: false,  // Sem container
  // showLegendBorder é ignorado
  // Resultado: apenas badges com padding mínimo, sem decoração
)
```

### 📐 Comportamento do Padding

O `ChartActionButtonTheme` agora **ajusta automaticamente** o tamanho dos botões baseado no padding:

```dart
// ✅ CORRETO - O botão cresce com o padding
actionButtonTheme: ChartActionButtonTheme(
  padding: EdgeInsets.all(20),  // Botão fica maior automaticamente
),

// ✅ CORRETO - Altura mínima + padding
actionButtonTheme: ChartActionButtonTheme(
  height: 50,                   // Altura mínima
  padding: EdgeInsets.all(16),  // Padding adicional
),

// ✅ CORRETO - Só padding, tamanho automático
actionButtonTheme: ChartActionButtonTheme(
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  // Altura se ajusta automaticamente ao conteúdo + padding
),
```

## Exemplo Completo

```dart
ModBarChart(
  title: 'Relatório de Vendas',
  titleAlign: TextAlign.center,
  backgroundColor: Colors.transparent, // Respeita tema
  
  // Zoom customizado
  enableZoom: true,
  zoomInIcon: Icons.add_circle_outline,
  zoomOutIcon: Icons.remove_circle_outline,
  zoomResetIcon: Icons.refresh,
  
  // Tema dos botões
  actionButtonTheme: ChartActionButtonTheme(
    height: 36,
    fontSize: 14,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: 18,
    lightSelectedBackgroundColor: Colors.blue,
    lightUnselectedBackgroundColor: Colors.transparent,
    lightSelectedTextColor: Colors.white,
    lightUnselectedTextColor: Colors.blue,
    lightBorderColor: Colors.blue,
  ),
  
  // Legendas sem container
  showLegendBorder: false,
  showLegendContainer: false,
  
  actions: [
    ChartActionButton(
      title: 'Hoje',
      isSelected: true,
      onPressed: () {},
    ),
    ChartActionButton(
      title: '7 dias',
      isSelected: false,
      onPressed: () {},
    ),
    ChartActionButton(
      title: '30 dias',
      isSelected: false,
      onPressed: () {},
    ),
  ],
  
  fetchData: (period) async {
    // Lógica de busca de dados
    return ModChartData(items: []);
  },
)
```

## Migração de Código Existente

O código existente continua funcionando sem alterações, pois todos os novos parâmetros são opcionais com valores padrão:

- `titleAlign` = `TextAlign.left` (padrão à esquerda)
- `backgroundColor` = `null` (transparente, respeita tema)
- `showLegendBorder` = `true` (mantém bordas)
- `showLegendContainer` = `true` (mantém containers)
- Ícones de zoom mantêm os ícones padrão se não especificados