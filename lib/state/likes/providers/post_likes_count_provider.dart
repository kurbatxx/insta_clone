import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/posts/typedefs/post_id.dart';
import 'package:insta_clone/state/constant/firebase_collection_name.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';

final postLikesCountProvider = StreamProvider.family.autoDispose<int, PostId>((
  ref,
  postId,
) {
  final controller = StreamController<int>.broadcast();

  controller.onListen = () {
    controller.sink.add(0);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(
        FirebaseFieldName.postId,
        isEqualTo: postId,
      )
      .snapshots()
      .listen(
    (snapshot) {
      controller.sink.add(
        snapshot.docs.length,
      );
    },
  );

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
