import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/comments/models/comment.dart';
import 'package:insta_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:insta_clone/views/components/animations/small_error_animation_view.dart';
import 'package:insta_clone/views/components/rich_two_parts_component.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;
  const CompactCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(comment.fromUserId),
    );
    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartsText(
            leftPart: userInfo.displayName, rightPart: comment.comment);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
