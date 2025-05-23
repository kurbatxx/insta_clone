import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:insta_clone/state/posts/typedefs/post_id.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';
import 'package:insta_clone/state/posts/typedefs/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likedBy,
    required DateTime date,
  }) : super(
          {
            FirebaseFieldName.postId: postId,
            FirebaseFieldName.userId: likedBy,
            FirebaseFieldName.date: date.toIso8601String(),
          },
        );
}
