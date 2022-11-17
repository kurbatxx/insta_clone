import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/auth/providers/user_id_provider.dart';
import 'package:insta_clone/state/comments/models/comment.dart';
import 'package:insta_clone/state/comments/providers/delete_comments_provider.dart';
import 'package:insta_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:insta_clone/views/components/animations/loading_animation_view.dart';
import 'package:insta_clone/views/components/animations/small_error_animation_view.dart';
import 'package:insta_clone/views/components/constants/strings.dart';
import 'package:insta_clone/views/components/dialogs/alert_dialog_modal.dart';
import 'package:insta_clone/views/components/dialogs/delete_dialog.dart';

class CommentTile extends HookConsumerWidget {
  final Comment comment;

  const CommentTile({
    super.key,
    required this.comment,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUserId,
      ),
    );
    return userInfo.when(
      data: (userInfo) {
        final currentUserId = ref.read(userIdProvider);
        return ListTile(
          trailing: currentUserId == comment.fromUserId
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDeleteComment =
                        await displayDeleteDialog(context);
                    if (shouldDeleteComment) {
                      ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                )
              : null,
          title: Text(
            userInfo.displayName,
          ),
          subtitle: Text(
            comment.comment,
          ),
        );
      },
      loading: () {
        return const LoadingAnimationView();
      },
      error: ((error, stackTrace) {
        return const SmallErrorAnimationView();
      }),
    );
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment)
          .present(context)
          .then((value) => value ?? false);
}
