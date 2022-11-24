import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/post_settings/typedefs/is_loading.dart';
import 'package:insta_clone/state/posts/notifiers/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (_) => DeletePostStateNotifier(),
);