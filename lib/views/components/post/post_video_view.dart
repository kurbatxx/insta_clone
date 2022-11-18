import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insta_clone/state/posts/models/post.dart';
import 'package:insta_clone/views/components/animations/error_animation_view.dart';
import 'package:insta_clone/views/components/animations/loading_animation_view.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.network(post.fileUrl);

    final isVideoPlayerReady = useState(false);

    useEffect(() {
      controller.initialize().then(
        (value) {
          isVideoPlayerReady.value = false;
          controller.setLooping(true);
          controller.play();
        },
      );
      return controller.dispose;
    }, [controller]);

    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );

      case false:
        return const LoadingAnimationView();
      default:
        return const ErrorAnimationView();
    }
  }
}
