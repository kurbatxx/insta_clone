import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/comments/notifiers/delete_comments_notifier.dart';
import 'package:insta_clone/state/post_settings/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
  (ref) => DeleteCommentStateNotifier(),
);
