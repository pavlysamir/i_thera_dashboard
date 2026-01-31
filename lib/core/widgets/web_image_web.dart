import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget getPlatformImage({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
  Widget? errorWidget,
}) {
  // Generate a unique ID for each image to avoid collisions
  final String viewId = 'image-element-${imageUrl.hashCode}-${DateTime.now().millisecondsSinceEpoch}';

  // Register the view factory
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) {
      final element = html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = _getBoxFit(fit);
      
      // Handle error
      element.onError.listen((event) {
        // We can't easily propagate this back to the Flutter widget synchronously to swap it,
        // but we can ensure the element handles it gracefully or shows a border.
        // For now, if the image breaks, the browser shows a broken image icon.
      });

      return element;
    },
  );

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewId),
  );
}

String _getBoxFit(BoxFit fit) {
  switch (fit) {
    case BoxFit.contain:
      return 'contain';
    case BoxFit.cover:
      return 'cover';
    case BoxFit.fill:
      return 'fill';
    case BoxFit.fitHeight:
      return 'contain'; // approximation
    case BoxFit.fitWidth:
      return 'contain'; // approximation
    case BoxFit.none:
      return 'none';
    case BoxFit.scaleDown:
      return 'scale-down';
  }
}
