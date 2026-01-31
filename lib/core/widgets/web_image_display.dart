import 'package:flutter/material.dart';
import 'web_image_io.dart' if (dart.library.html) 'web_image_web.dart';

class WebImageDisplay extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const WebImageDisplay({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return getPlatformImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}
