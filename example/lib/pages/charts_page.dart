import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  String selectedPeriod = 'geral';

  // Simulação de dados para diferentes períodos
  final Map<String, ChartData> mockData = {
    'geral': ChartData(
      title: 'DESEMPENHO GERAL',
      period: 'geral',
      unit: '',
      updatedAt: DateTime.now(),
      data: [
        ChartDataItem(label: 'Cesar', value: 15.4),
        ChartDataItem(label: 'Rodrigo', value: 12.5),
        ChartDataItem(label: 'Fred', value: 10.0),
        ChartDataItem(label: 'Ana', value: 5.0),
        ChartDataItem(label: 'Maria', value: 8.7),
        ChartDataItem(label: 'João', value: 11.3),
        ChartDataItem(label: 'Pedro', value: 9.2),
        ChartDataItem(label: 'Lucas', value: 7.8),
      ],
      maxHint: 20,
    ),
    'mes': ChartData(
      title: 'DESEMPENHO MENSAL',
      period: 'mes',
      unit: '%',
      unitPosition: UnitPosition.right, // Unidade à direita (18,2%)
      updatedAt: DateTime.now(),
      data: [
        ChartDataItem(label: 'Cesar', value: 18.2),
        ChartDataItem(label: 'Rodrigo', value: 14.7),
        ChartDataItem(label: 'Fred', value: 12.3),
        ChartDataItem(label: 'Ana', value: 8.5),
        ChartDataItem(label: 'Maria', value: 10.1),
        ChartDataItem(label: 'João', value: 13.6),
        ChartDataItem(label: 'Pedro', value: 11.4),
        ChartDataItem(label: 'Lucas', value: 9.9),
        ChartDataItem(label: 'Carlos', value: 15.7),
        ChartDataItem(label: 'Julia', value: 12.8),
        ChartDataItem(label: 'Rafael', value: 14.2),
        ChartDataItem(label: 'Beatriz', value: 11.5),
        ChartDataItem(label: 'Gabriel', value: 13.3),
        ChartDataItem(label: 'Fernanda', value: 10.6),
        ChartDataItem(label: 'Bruno', value: 9.4),
      ],
      maxHint: 25,
    ),
    'ano': ChartData(
      title: 'DESEMPENHO ANUAL',
      period: 'ano',
      unit: 'k',
      unitPosition: UnitPosition.right, // Unidade à direita (125,4k)
      updatedAt: DateTime.now(),
      data: [
        ChartDataItem(label: 'Cesar', value: 125.4),
        ChartDataItem(label: 'Rodrigo', value: 98.5),
        ChartDataItem(label: 'Fred', value: 87.0),
        ChartDataItem(label: 'Ana', value: 65.0),
        ChartDataItem(label: 'Maria', value: 72.7),
        ChartDataItem(label: 'João', value: 91.3),
      ],
      maxHint: 150,
    ),
  };

  // Simula chamada à API
  Future<ChartData> fetchChartData(String period) async {
    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Simula erro aleatório para demonstração (10% de chance)
    if (DateTime.now().second % 10 == 0) {
      throw Exception('Erro ao carregar dados do servidor');
    }

    return mockData[period] ?? mockData['geral']!;
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'charts'.tr,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gráficos de Barras Horizontais',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Exemplos de uso do componente ModBarChart com diferentes configurações',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 32),

            // Exemplo 1: Gráfico básico com dados estáticos
            ModCard(
              header: const Text(
                'Exemplo 1: Gráfico com Dados Estáticos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'VENDAS POR CATEGORIA',
                barHeight: 25,
                barSpacing: 10,
                orientation: BarChartOrientation.horizontal,
                barRadius: 16,
                enableFooter: true,
                enableZoom: false,
                //barChartWidth: 900,
                chartContainerHeight: 400,
                titleStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                initialData: ChartData(
                  title: 'VENDAS POR CATEGORIA',
                  period: 'geral',
                  unit: 'R\$',

                  unitPosition:
                      UnitPosition.left, // Unidade à esquerda (R$ 45.780)
                  updatedAt: DateTime.now(),
                  data: [
                    ChartDataItem(label: 'Eletrônicos', value: 45780),
                    ChartDataItem(label: 'Roupas', value: 32150),
                    ChartDataItem(label: 'Alimentos', value: 28900),
                    ChartDataItem(label: 'Livros', value: 15670),
                    ChartDataItem(label: 'Esportes', value: 21340),
                  ],
                  maxHint: 50000,
                ),
                showValueLabels: true,
                showTooltip: true,
                onBarClick: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Clicou em: ${item.label} - ${item.value}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Exemplo 2: Gráfico com carregamento dinâmico
            ModCard(
              header: const Text(
                'Exemplo 2: Gráfico com Carregamento Dinâmico e Filtros',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'DESEMPENHO DA EQUIPE',
                darkBorderColor: Colors.red,
                orientation: BarChartOrientation.vertical,
                //barChartWidth: 900,
                enableFooter: true,
                chartContainerHeight: 300,
                darkSelectedBackgroundColor: Colors.red,
                darkSelectedTextColor: Colors.white,
                darkUnselectedBackgroundColor:
                    Colors.red.withValues(alpha: 0.2),
                darkUnselectedTextColor: Colors.red.shade700,
                lightSelectedBackgroundColor: Colors.blue,
                lightSelectedTextColor: Colors.white,
                lightUnselectedBackgroundColor:
                    Colors.blue.withValues(alpha: 0.2),
                lightUnselectedTextColor: Colors.blue.shade700,
                lightBorderColor: Colors.blue.withValues(alpha: 0.3),
                actions: [
                  ChartActionButton(
                    title: 'Geral',
                    isSelected: selectedPeriod == 'geral',

                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'geral';
                      });
                    },
                    // Exemplo de TextStyle customizado (opcional)
                    // textStyle: const TextStyle(fontSize: 16),
                  ),
                  ChartActionButton(
                    title: 'Mês',
                    isSelected: selectedPeriod == 'mes',
                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'mes';
                      });
                    },
                  ),
                  ChartActionButton(
                    title: 'Ano',
                    isSelected: selectedPeriod == 'ano',
                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'ano';
                      });
                    },
                  ),
                ],
                fetchData: fetchChartData,
                onPeriodChange: (period) {
                  debugPrint('Período alterado para: $period');
                },
                onDataLoaded: (period, data) {
                  debugPrint(
                      'Dados carregados para $period: ${data.length} itens');
                },
                onBarClick: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.label}: ${item.value}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onError: (error) {
                  debugPrint('Erro ao carregar dados: $error');
                },
              ),
            ),
            const SizedBox(height: 24),

            // Exemplo 3: Gráfico customizado
            ModCard(
              header: const Text(
                'Exemplo 3: Gráfico com Estilo Customizado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'PROGRESSO DO PROJETO',
                titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                initialData: ChartData(
                  title: 'PROGRESSO DO PROJETO',
                  period: 'geral',
                  unit: '%',

                  unitPosition: UnitPosition.right, // Percentual à direita
                  updatedAt: DateTime.now(),
                  data: [
                    ChartDataItem(label: 'Frontend', value: 85),
                    ChartDataItem(label: 'Backend', value: 72),
                    ChartDataItem(label: 'Database', value: 90),
                    ChartDataItem(label: 'DevOps', value: 65),
                    ChartDataItem(label: 'Testing', value: 58),
                    ChartDataItem(label: 'Documentation', value: 45),
                  ],
                  maxHint: 100,
                ),
                // barHeight: 40,
                // barSpacing: 20,
                // barRadius: 12,
                customColors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.orange,
                  Colors.red,
                  Colors.teal,
                ],
                footer: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Última atualização: ${DateTime.now().toString().substring(0, 16)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Text(
                        'Meta: 80%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Exemplo 4: Muitos itens com scroll
            ModCard(
              header: const Text(
                'Exemplo 4: Gráfico com Scroll (Muitos Itens)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'RANKING DE VENDEDORES',
                initialData: ChartData(
                  title: 'RANKING DE VENDEDORES',
                  period: 'geral',
                  unit: '',
                  updatedAt: DateTime.now(),
                  data: List.generate(
                    20,
                    (index) => ChartDataItem(
                      label: 'Vendedor ${index + 1}',
                      value: (20 - index) * 5.0 + (index * 2.5),
                    ),
                  ),
                  maxHint: 150,
                ),
                maxItemsBeforeScroll: 10,
                showValueLabels: true,
              ),
            ),
            const SizedBox(height: 24),

            // Exemplo 5: Cores customizadas para os botões
            ModCard(
              header: const Text(
                'Exemplo 5: Cores Customizadas dos Botões (Light/Dark)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'CORES PERSONALIZADAS',
                showTooltip: true,
                actions: [
                  ChartActionButton(
                    title: 'Q1',
                    isSelected: selectedPeriod == 'q1',
                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'q1';
                      });
                    },
                  ),
                  ChartActionButton(
                    title: 'Q2',
                    isSelected: selectedPeriod == 'q2',
                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'q2';
                      });
                    },
                  ),
                  ChartActionButton(
                    title: 'Q3',
                    isSelected: selectedPeriod == 'q3',
                    onPressed: () {
                      setState(() {
                        selectedPeriod = 'q3';
                      });
                    },
                  ),
                ],
                // Cores customizadas para Light Theme
                lightSelectedBackgroundColor: Colors.green,
                lightSelectedTextColor: Colors.white,
                lightUnselectedBackgroundColor:
                    Colors.green.withValues(alpha: 0.15),
                lightUnselectedTextColor: Colors.green.shade700,
                lightBorderColor: Colors.green.withValues(alpha: 0.3),

                // Cores customizadas para Dark Theme
                darkSelectedBackgroundColor: Colors.orange,
                darkSelectedTextColor: Colors.black,
                darkUnselectedBackgroundColor:
                    Colors.orange.withValues(alpha: 0.2),
                darkUnselectedTextColor: Colors.orange.shade300,
                darkBorderColor: Colors.orange.withValues(alpha: 0.4),

                initialData: ChartData(
                  title: 'CORES PERSONALIZADAS',
                  period: 'q1',
                  unit: 'pts',
                  unitPosition: UnitPosition.right,
                  updatedAt: DateTime.now(),
                  data: [
                    ChartDataItem(label: 'Vendas', value: 92),
                    ChartDataItem(label: 'Marketing', value: 78),
                    ChartDataItem(label: 'Suporte', value: 85),
                    ChartDataItem(label: 'Financeiro', value: 67),
                  ],
                  maxHint: 100,
                ),
                showValueLabels: true,
              ),
            ),
            const SizedBox(height: 24),

            // Exemplo 6: Footer interativo com legenda
            ModCard(
              header: const Text(
                'Exemplo 6: Footer Interativo com Legenda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ModBarChart(
                title: 'VENDAS POR CATEGORIA',
                enableFooter: true, // Habilita o footer interativo
                emptyStateTitle: 'Selecione pelo menos uma categoria',
                emptyStateIcon: Icons.category_outlined,
                initialData: ChartData(
                  title: 'VENDAS POR CATEGORIA',
                  period: 'geral',
                  unit: 'R\$',
                  unitPosition: UnitPosition.left,
                  updatedAt: DateTime.now(),
                  data: [
                    ChartDataItem(label: 'Eletrônicos', value: 45780),
                    ChartDataItem(label: 'Roupas', value: 32150),
                    ChartDataItem(label: 'Alimentos', value: 28900),
                    ChartDataItem(label: 'Livros', value: 15670),
                    ChartDataItem(label: 'Esportes', value: 21340),
                    ChartDataItem(label: 'Casa', value: 18900),
                  ],
                  maxHint: 50000,
                ),
                showValueLabels: true,
                showTooltip: true,
                onBarClick: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Clicou em: ${item.label} - ${item.value}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Código de exemplo
            ModCard(
              header: const Text(
                'Código de Exemplo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  '''// Exemplo básico
ModBarChart(
  title: 'MEU GRÁFICO',
  initialData: ChartData(
    title: 'MEU GRÁFICO',
    period: 'geral',
    unit: 'R\$',
    unitPosition: UnitPosition.left, // R\$ 100 (esquerda) ou 100 R\$ (direita)
    data: [
      ChartDataItem(label: 'Item 1', value: 100),
      ChartDataItem(label: 'Item 2', value: 85),
      ChartDataItem(label: 'Item 3', value: 70),
    ],
  ),
)

// Exemplo com carregamento dinâmico e cores customizadas
ModBarChart(
  title: 'GRÁFICO DINÂMICO',
  actions: [...],
  fetchData: (period) async {
    final response = await api.get('/chart/\$period');
    return ChartData.fromJson(response.data);
  },

  // Cores customizadas - Light Theme
  lightSelectedBackgroundColor: Colors.blue,
  lightSelectedTextColor: Colors.white,
  lightUnselectedBackgroundColor: Colors.blue.withValues(alpha: 0.1),
  lightUnselectedTextColor: Colors.blue,
  lightBorderColor: Colors.blue.withValues(alpha: 0.2),

  // Cores customizadas - Dark Theme
  darkSelectedBackgroundColor: Colors.orange,
  darkSelectedTextColor: Colors.black,
  darkUnselectedBackgroundColor: Colors.orange.withValues(alpha: 0.2),
  darkUnselectedTextColor: Colors.orange.shade300,
  darkBorderColor: Colors.orange.withValues(alpha: 0.3),

  onBarClick: (item) {
    print('Clicou em: \${item.label}');
  },
)''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
