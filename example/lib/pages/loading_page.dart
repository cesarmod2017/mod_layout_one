import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Loading',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            mod.ModCard(
              header: const Text(
                "Basic Loading Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Center(
                child: mod.ModButton(
                  title: "Show Basic Loading",
                  type: mod.ModButtonType.none,
                  borderType: mod.ModBorderType.solid,
                  borderColor: mod.ModButtonType.primary,
                  onPressed: () async {
                    mod.ModLoading.instance.show(
                      config: mod.ModLoadingConfig(
                        title: "Carregando...",
                        orientation: mod.ModLoadingOrientation.horizontal,
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    mod.ModLoading.instance.close();
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            const mod.ModCodeExample(
              code: '''// Loading Básico
ModLoading.instance.show(
  config: ModLoadingConfig(
    title: "Carregando...",
    orientation: ModLoadingOrientation.horizontal,
  ),
);

// Fechar loading
await Future.delayed(const Duration(seconds: 2));
ModLoading.instance.close();''',
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Custom Loading Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Center(
                child: mod.ModButton(
                  title: "Show Custom Loading",
                  type: mod.ModButtonType.none,
                  borderType: mod.ModBorderType.solid,
                  borderColor: mod.ModButtonType.primary,
                  onPressed: () async {
                    final config = mod.ModLoadingConfig(
                      icon: Icons.hourglass_empty,
                      size: 32,
                      position: mod.ModLoadingPosition.center,
                      //backgroundColor: Colors.blue,
                      borderRadius: 16,
                      padding: const EdgeInsets.all(24),
                      barrierDismissible: false,
                      title: "Loading",
                      orientation: mod.ModLoadingOrientation.horizontal,
                    );
                    mod.ModLoading.instance.show(
                      config: config,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    mod.ModLoading.instance.close();
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            const mod.ModCodeExample(
              code: '''// Loading Customizado
final config = ModLoadingConfig(
  icon: Icons.hourglass_empty,
  size: 32,
  position: ModLoadingPosition.center,
  borderRadius: 16,
  padding: const EdgeInsets.all(24),
  barrierDismissible: false,
  title: "Loading",
  orientation: ModLoadingOrientation.horizontal,
);

ModLoading.instance.show(config: config);

await Future.delayed(const Duration(seconds: 2));
ModLoading.instance.close();''',
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Auto-Close on Navigation Demo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  const Text(
                    "This demo shows that the loading overlay is automatically closed when navigating to another screen. "
                    "The ModLoadingNavigatorObserver (added to navigatorObservers in GetMaterialApp) "
                    "intercepts navigation events and calls ModLoading.closeAll().",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: mod.ModButton(
                      title: "Open Loading and Navigate after 5s",
                      type: mod.ModButtonType.none,
                      borderType: mod.ModBorderType.solid,
                      borderColor: mod.ModButtonType.primary,
                      onPressed: () async {
                        mod.ModLoading.instance.show(
                          config: mod.ModLoadingConfig(
                            title: "Navigating in 5 seconds...",
                            orientation: mod.ModLoadingOrientation.horizontal,
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 5));
                        Get.toNamed('/textboxes');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// Auto-Close com NavigatorObserver
// Adicione ao GetMaterialApp:
GetMaterialApp(
  navigatorObservers: [
    ModLoadingNavigatorObserver(),
  ],
  ...
);

// O loading será fechado automaticamente ao navegar
ModLoading.instance.show(
  config: ModLoadingConfig(
    title: "Navigating in 5 seconds...",
    orientation: ModLoadingOrientation.horizontal,
  ),
);
await Future.delayed(const Duration(seconds: 5));
Get.toNamed('/other-page'); // Loading fecha automaticamente''',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
