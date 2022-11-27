import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/auth/providers/user_id_provider.dart';
import 'package:insta_clone/state/posts/typedefs/post_id.dart';
import 'package:insta_clone/state/constant/firebase_collection_name.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';

final hasLikedPostProvider = StreamProvider.family.autoDispose<bool, PostId>((
  ref,
  PostId postId,
) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    return Stream<bool>.value(false);
  }

  final controller = StreamController<bool>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: postId)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      controller.add(true);
    } else {
      controller.add(false);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
