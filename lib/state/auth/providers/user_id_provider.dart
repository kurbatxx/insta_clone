import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/auth/posts/typedefs/user_id.dart';
import 'package:insta_clone/state/auth/providers/auth_state_provider.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
