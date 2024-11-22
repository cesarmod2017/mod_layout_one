import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatelessWidget {
  final String userName;
  final String? userEmail;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogout;
  final bool showFullProfile;

  const UserProfile({
    super.key,
    required this.userName,
    this.userEmail,
    this.avatarUrl,
    this.onProfileTap,
    this.onLogout,
    this.showFullProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showProfileMenu(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(userName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 18))
                  : null,
            ),
            if (showFullProfile) ...[
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: Get.theme.appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (userEmail != null)
                    Text(
                      userEmail!,
                      style: TextStyle(
                        color: Get.theme.appBarTheme.foregroundColor
                            ?.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ],
        ),
      ),
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
      items: [
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('profile'.tr),
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'logout'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'profile') {
        onProfileTap?.call();
      } else if (value == 'logout') {
        onLogout?.call();
      }
    });
  }
}
