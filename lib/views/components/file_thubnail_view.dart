import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/image_upload/models/thumbnail_request.dart';
import 'package:insta_clone/state/image_upload/providers/thumbnail_provider.dart';
import 'package:insta_clone/views/components/animations/loading_animation_view.dart';
import 'package:insta_clone/views/components/animations/small_error_animation_view.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;

  const FileThumbnailView({
    super.key,
    required this.thumbnailRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(thumbnailRequest));
    return thumbnail.when(
      data: (imageWihAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWihAspectRatio.aspectRatio,
          child: imageWihAspectRatio.image,
        );
      },
      loading: () => const LoadingAnimationView(),
      error: ((error, stackTrace) {
        return const SmallErrorAnimationView();
      }),
    );
  }
}
