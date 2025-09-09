import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/widgets/buttons/buttons.dart';

class NoAccessScreen extends StatefulWidget {
  final String? loginRoute;
  final VoidCallback? onLoginRedirect;

  const NoAccessScreen({
    super.key,
    this.loginRoute,
    this.onLoginRedirect,
  });

  @override
  State<NoAccessScreen> createState() => _NoAccessScreenState();
}

class _NoAccessScreenState extends State<NoAccessScreen> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de acesso negado
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Título
              Text(
                'no_access_title'.tr,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Mensagem
              Text(
                'no_access_message'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              
              const SizedBox(height: 40),
              
              // Botão de logout/login
              ModButton(
                title: 'logout_button'.tr,
                type: ModButtonType.primary,
                size: ModButtonSize.lg,
                leftIcon: Icons.logout,
                onPressed: _isNavigating ? null : () async {
                  if (_isNavigating) return;
                  
                  setState(() {
                    _isNavigating = true;
                  });
                  
                  debugPrint('[NoAccessScreen] Login button pressed');
                  debugPrint('[NoAccessScreen] loginRoute: ${widget.loginRoute}');
                  debugPrint('[NoAccessScreen] onLoginRedirect callback: ${widget.onLoginRedirect != null}');
                  
                  try {
                    if (widget.onLoginRedirect != null) {
                      debugPrint('[NoAccessScreen] Executing custom callback');
                      widget.onLoginRedirect!();
                    } else if (widget.loginRoute != null && widget.loginRoute!.isNotEmpty) {
                      // Verificar se não estamos tentando navegar para a rota atual
                      final currentRoute = Get.currentRoute;
                      debugPrint('[NoAccessScreen] Current route: $currentRoute');
                      debugPrint('[NoAccessScreen] Target loginRoute: ${widget.loginRoute}');
                      
                      if (currentRoute == widget.loginRoute) {
                        debugPrint('[NoAccessScreen] ERROR: loginRoute is same as current route - this would create a loop!');
                        Get.snackbar(
                          'Configuration Error'.tr,
                          'Login route cannot be the same as current route. Please check your loginRoute configuration.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          colorText: Theme.of(context).colorScheme.onError,
                          duration: const Duration(seconds: 5),
                        );
                      } else {
                        debugPrint('[NoAccessScreen] Navigating to loginRoute: ${widget.loginRoute}');
                        Get.offAllNamed(widget.loginRoute!);
                      }
                    } else {
                      debugPrint('[NoAccessScreen] No login route or callback provided - falling back to close app');
                      // Se não há rota ou callback, pelo menos mostra uma mensagem ou fecha o app
                      Get.snackbar(
                        'Info'.tr,
                        'Please contact administrator for access',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } catch (e) {
                    debugPrint('[NoAccessScreen] Navigation error: $e');
                    setState(() {
                      _isNavigating = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}