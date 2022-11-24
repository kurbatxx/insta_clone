import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_clone/state/comments/typedefs/post_id.dart';
import 'package:insta_clone/state/constant/firebase_collection_name.dart';
import 'package:insta_clone/state/constant/firebase_field_name.dart';
import 'package:insta_clone/state/image_upload/extentions/get_collection_name_from_file_type.dart';
import 'package:insta_clone/state/post_settings/typedefs/is_loading.dart';
import 'package:insta_clone/state/posts/models/post.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);
  set isLoading(bool value) => state = value;

  Future<bool> deletePost({
    required Post post,
  }) async {
    isLoading = true;

    try {
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      await _deleteAllDocumenrs(
        postId: post.postId,
        inCollection: FirebaseCollectionName.comments,
      );

      await _deleteAllDocumenrs(
        postId: post.postId,
        inCollection: FirebaseCollectionName.likes,
      );

      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(
            FirebaseFieldName.postId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();

      for (final post in postInCollection.docs) {
        await post.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocumenrs({
    required PostId postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
        maxAttempts: 3,
        timeout: const Duration(seconds: 20), (transaction) async {
      final query = await FirebaseFirestore.instance
          .collection(inCollection)
          .where(
            FirebaseFieldName.postId,
            isEqualTo: postId,
          )
          .get();

      for (final doc in query.docs) {
        transaction.delete(doc.reference);
      }
    });
  }
}
