import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/enums/date_sorting.dart';
import 'package:insta_clone/state/comments/models/post_comments_request.dart';
import 'package:insta_clone/state/posts/models/post.dart';
import 'package:insta_clone/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:insta_clone/state/posts/providers/delete_post_provider.dart';
import 'package:insta_clone/state/posts/providers/specific_post_with_coments_provider.dart';
import 'package:insta_clone/views/components/animations/error_animation_view.dart';
import 'package:insta_clone/views/components/animations/loading_animation_view.dart';
import 'package:insta_clone/views/components/animations/small_error_animation_view.dart';
import 'package:insta_clone/views/components/comment/compact_comment_column.dart';
import 'package:insta_clone/views/components/dialogs/alert_dialog_modal.dart';
import 'package:insta_clone/views/components/dialogs/delete_dialog.dart';
import 'package:insta_clone/views/components/like_button.dart';
import 'package:insta_clone/views/components/likes_conts_view.dart';
import 'package:insta_clone/views/components/post/post_date_view.dart';
import 'package:insta_clone/views/components/post/post_diplay_name_and_message_view.dart';
import 'package:insta_clone/views/components/post/post_image_or_video_view.dart';
import 'package:insta_clone/views/constants/strings.dart';
import 'package:insta_clone/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    final postWithComments = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          postWithComments.when(
            data: (postWithComments) {
              return IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  final url = postWithComments.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
              );
            },
            error: (error, stackTrace) => const SmallErrorAnimationView(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          if (canDeletePost.value ?? false)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context)
                    .then(
                      (shouldDelete) => shouldDelete ?? false,
                    );
                if (shouldDeletePost) {
                  await ref
                      .read(
                        deletePostProvider.notifier,
                      )
                      .deletePost(
                        post: widget.post,
                      );
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            )
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (postWithComments.post.allowLikes)
                      LikeButton(postId: postId),
                    if (postWithComments.post.allowComments)
                      IconButton(
                        icon: const Icon(Icons.mode_comment_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((_) {
                                return PostCommentsView(postId: postId);
                              }),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                PostDisplayNameAndMessageView(
                  post: postWithComments.post,
                ),
                PostDateView(
                  dateTime: postWithComments.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(postId: postId),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
