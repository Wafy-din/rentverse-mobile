import 'package:flutter/material.dart';

Widget buildNetworkImage(String url,
    {BoxFit fit = BoxFit.cover, double? width, double? height}) {
  return Image.network(
    url,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) {
      // Check for 404 in the error message
      final is404 = error.toString().contains('404');

      if (is404) {
        return Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.image, color: Colors.grey)));
      }
      return Container(
        color: Colors.grey.shade200,
        width: width,
        height: height,
        child:
            const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    },
  );
}

ImageProvider buildNetworkImageProvider(String url) {
  // NetworkImage doesn't support errorBuilder directly.
  // For places requiring ImageProvider (like CircleAvatar), we might need a workaround or just use the widget version if possible.
  // Or better, wrapping CachedNetworkImage if available.
  return NetworkImage(url);
}
