import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/image_uploads/exception/could_not_build_thumbnail_exception.dart';
import 'package:insta_clone/state/image_uploads/extentions/get_aspect_ratio.dart';
import 'package:insta_clone/state/image_uploads/models/file_type.dart';
import 'package:insta_clone/state/image_uploads/models/image_with_aspect_ratio.dart';
import 'package:insta_clone/state/image_uploads/models/thumbnail_request.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final thumbnailProvider =
    FutureProvider.family.autoDispose<ImageWihAspectRatio, ThumbnailRequest>((
  ref,
  ThumbnailRequest request,
) async {
  final Image image;
  switch (request.fileType) {
    case FileType.image:
      image = Image.file(
        request.file,
        fit: BoxFit.fitHeight,
      );
      break;
    case FileType.video:
      final thumb = await VideoThumbnail.thumbnailData(
        video: request.file.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );
      if (thumb == null) {
        throw const CouldNotBuildThumbnailException();
      }
      image = Image.memory(
        thumb,
        fit: BoxFit.fitHeight,
      );
      break;
  }
  final aspectRatio = await image.getAspectRatio();
  return ImageWihAspectRatio(
    image: image,
    aspectRatio: aspectRatio,
  );
});
