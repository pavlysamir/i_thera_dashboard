import 'package:flutter/material.dart';

Widget getPlatformImage({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
  Widget? errorWidget,
}) {
  return Image.network(
    imageUrl,
    width: width,
    height: height,
    fit: fit,
    loadingBuilder: placeholder != null
        ? (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder;
          }
        : null,
    errorBuilder: (context, error, stackTrace) {
      return errorWidget ?? const Center(child: Icon(Icons.error));
    },
  );
}
