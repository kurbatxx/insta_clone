import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/comments/notifiers/send_comment_notifier.dart';
import 'package:insta_clone/state/post_settings/typedefs/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (_) => SendCommentNotifier(),
);
