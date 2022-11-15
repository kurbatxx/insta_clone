import 'package:flutter/material.dart';

@immutable
class ImageWihAspectRatio {
  final Image image;
  final double aspectRatio;

  const ImageWihAspectRatio({
    required this.image,
    required this.aspectRatio,
  });
}
