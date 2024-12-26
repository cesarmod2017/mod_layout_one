import 'package:example/main.dart';
import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }
}
