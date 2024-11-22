// lib/app/core/widgets/profile_widget.dart
import 'package:example/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends GetView<AppController> {
  final bool showFullProfile;

  const ProfileWidget({
    super.key,
    this.showFullProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showFullProfile
          ? _showProfileMenu(context)
          : _showMobileMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            if (showFullProfile) ...[
              const SizedBox(width: 12),
              _buildUserInfo(),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down),
            ],
          ],
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text('my_account'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text('settings'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.red),
              title:
                  Text('logout'.tr, style: const TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _showLogoutConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            backgroundImage: controller.user.value.photoUrl != null
                ? NetworkImage(controller.user.value.photoUrl!)
                : controller.user.value.avatarPath != null
                    ? AssetImage(controller.user.value.avatarPath!)
                        as ImageProvider<Object>?
                    : null,
            onBackgroundImageError: (_, __) {
              // Handle the error by setting a default image or icon
              // No return statement needed
            },
          ),
        ));
  }

  Widget _buildUserInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).size.width < 300) {
          return const SizedBox.shrink();
        }

        return Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.user.value.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller.user.value.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        _buildPopupMenuItem(
          icon: Icons.person_outline,
          text: 'my_account'.tr,
          value: 'account',
        ),
        _buildPopupMenuItem(
          icon: Icons.settings_outlined,
          text: 'settings'.tr,
          value: 'settings',
        ),
        const PopupMenuDivider(),
        _buildPopupMenuItem(
          icon: Icons.logout_outlined,
          text: 'logout'.tr,
          value: 'logout',
          isDestructive: true,
        ),
      ],
    ).then((value) => _handleMenuSelection(value));
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required IconData icon,
    required String text,
    required String value,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red : null,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String? value) {
    switch (value) {
      case 'account':
        Get.toNamed('/profile');
        break;
      case 'settings':
        Get.toNamed('/settings');
        break;
      case 'logout':
        _showLogoutConfirmation();
        break;
    }
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('logout_confirm'.tr),
        content: Text('logout_message'.tr),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
