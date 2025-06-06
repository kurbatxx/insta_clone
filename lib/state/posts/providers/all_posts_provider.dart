import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/constant/firebase_collection_name.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';
import 'package:insta_clone/state/posts/models/post.dart';

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs.map(
        (doc) => Post(
          postId: doc.id,
          json: doc.data(),
        ),
      );
      controller.sink.add(posts);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
