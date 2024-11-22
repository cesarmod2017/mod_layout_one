import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ModAvatarShape { square, circle, triangle }

enum ModAvatarSize { lg, md, sm, xs }

class ModAvatar extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final String? imageUrl;
  final ModAvatarShape shape;
  final ModAvatarSize? size;
  final double? customSize;
  final Color backgroundColor;
  final Color textColor;

  const ModAvatar({
    super.key,
    this.text,
    this.icon,
    this.imageUrl,
    this.shape = ModAvatarShape.circle,
    this.size = ModAvatarSize.md,
    this.customSize,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  }) : assert(text != null || icon != null || imageUrl != null,
            'At least one of text, icon or imageUrl must be provided');

  double _getSize() {
    if (customSize != null) return customSize!;

    switch (size) {
      case ModAvatarSize.lg:
        return 56;
      case ModAvatarSize.md:
        return 40;
      case ModAvatarSize.sm:
        return 32;
      case ModAvatarSize.xs:
        return 24;
      default:
        return 40;
    }
  }

  String _getInitials(String text) {
    final nameParts = text.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
        .toUpperCase();
  }

  ClipPath _getClipPath() {
    switch (shape) {
      case ModAvatarShape.square:
        return ClipPath(
          clipper: SquareClipper(),
        );
      case ModAvatarShape.circle:
        return ClipPath(
          clipper: CircleClipper(),
        );
      case ModAvatarShape.triangle:
        return ClipPath(
          clipper: TriangleClipper(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = _getSize();

    Widget child;
    if (imageUrl != null) {
      child = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else if (icon != null) {
      child = Icon(
        icon,
        size: size * 0.5,
        color: textColor,
      );
    } else {
      child = Text(
        _getInitials(text!),
        style: TextStyle(
          color: textColor,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return ClipPath(
      clipper: _getClipPath().clipper,
      child: Container(
        width: size,
        height: size,
        color: backgroundColor,
        child: Center(child: child),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SquareClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
