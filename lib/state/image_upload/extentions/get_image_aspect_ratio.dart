import 'dart:async';

import 'package:flutter/material.dart' as material
    show Image, ImageConfiguration, ImageStreamListener;

extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    final completer = Completer<double>();
    image.resolve(const material.ImageConfiguration()).addListener(
      material.ImageStreamListener(
        (imageInfo, sinhronousCall) {
          final aspectRatio = imageInfo.image.width / imageInfo.image.height;
          imageInfo.dispose();
          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
