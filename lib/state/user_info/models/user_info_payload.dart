import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:insta_clone/state/posts/typedefs/user_id.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName ?? '',
            FirebaseFieldName.email: email ?? '',
          },
        );
}
