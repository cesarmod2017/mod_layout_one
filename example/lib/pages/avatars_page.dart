import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class AvatarsPage extends StatelessWidget {
  const AvatarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomLayout(
      title: 'Avatars',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: Text(
                "Sample Avatars",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModLabel(text: "Basic *Avatar* Examples:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModAvatar(
                        imageUrl: 'https://i.pravatar.cc/150?img=1',
                        size: ModAvatarSize.lg,
                      ),
                      ModAvatar(
                        imageUrl: 'https://i.pravatar.cc/150?img=2',
                        size: ModAvatarSize.lg,
                        shape: ModAvatarShape.square,
                      ),
                      ModAvatar(
                        imageUrl: 'https://i.pravatar.cc/150?img=3',
                        size: ModAvatarSize.lg,
                        shape: ModAvatarShape.triangle,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Text and Icon Avatars:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModAvatar(
                        text: "John Doe",
                        size: ModAvatarSize.md,
                      ),
                      ModAvatar(
                        icon: Icons.person,
                        size: ModAvatarSize.md,
                        backgroundColor: Colors.green,
                      ),
                      ModAvatar(
                        text: "Jane Smith",
                        size: ModAvatarSize.md,
                        shape: ModAvatarShape.square,
                        backgroundColor: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Different Sizes:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModAvatar(
                        text: "XS",
                        size: ModAvatarSize.xs,
                      ),
                      ModAvatar(
                        text: "SM",
                        size: ModAvatarSize.sm,
                      ),
                      ModAvatar(
                        text: "MD",
                        size: ModAvatarSize.md,
                      ),
                      ModAvatar(
                        text: "LG",
                        size: ModAvatarSize.lg,
                      ),
                      ModAvatar(
                        text: "Custom Size",
                        customSize: 100,
                      ),
                    ],
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
