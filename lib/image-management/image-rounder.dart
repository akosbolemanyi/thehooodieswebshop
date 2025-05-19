import 'dart:typed_data';
import 'package:flutter/material.dart';

/**
 * This widget wraps the images into a round framing for display.
 */

class RoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double width;

  RoundImage(
    this.provider, {
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: width,
      ),
    );
  }

  factory RoundImage.url(
    String url, {
    required double height,
    required double width,
  }) {
    return RoundImage(
      NetworkImage(url),
      height: height,
      width: width,
    );
  }

  factory RoundImage.memory(
    Uint8List data, {
    required double height,
    required double width,
  }) {
    return RoundImage(
      MemoryImage(data),
      height: height,
      width: width,
    );
  }
}
