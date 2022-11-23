import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/comments/extensions/comments_sorting_by_request.dart';
import 'package:insta_clone/state/comments/models/comment.dart';
import 'package:insta_clone/state/comments/models/post_comments_request.dart';
import 'package:insta_clone/state/comments/models/post_with_comments.dart';
import 'package:insta_clone/state/constant/firebase_collection_name.dart';
import 'package:insta_clone/state/posts/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<PostWithComments>();

  Post? post;
  Iterable<Comment>? comments;

  void notify() {
    final localPost = post;
    if (localPost == null) {
      return;
    }

    final outputComments = (comments ?? []).applySortingFrom(
      request,
    );

    final result = PostWithComments(
      post: localPost,
      comments: outputComments,
    );

    controller.sink.add(result);
  }

  final postSub = FirebaseFirestore.instance
      .collection(
        FirebaseCollectionName.posts,
      )
      .where(
        FieldPath.documentId,
        isEqualTo: request.postId,
      )
      .limit(1)
      .snapshots()
      .listen(
        (snaphot) {},
      );

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
