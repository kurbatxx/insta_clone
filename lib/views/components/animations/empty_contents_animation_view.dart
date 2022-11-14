import 'package:insta_clone/views/components/animations/lottie_animation_view.dart';
import 'package:insta_clone/views/components/animations/models/lottie_animations.dart';

class EmptyContentsAnimationView extends LottieAnimationView {
  const EmptyContentsAnimationView({super.key})
      : super(
          animation: LottieAnimation.empty,
        );
}
