import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/providers.dart';
import 'package:so_vuon/data/models/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  CategoryRepository(this._firestore, this._uid);

  // 카테고리 스트림 가져오기
  Stream<List<Category>> getCategories() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromJson(doc.data(), doc.id)).toList();
    });
  }

  // 카테고리 추가
  Future<void> addCategory(String name) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('categories')
        .add({'name': name});
  }

  // 카테고리 수정
  Future<void> updateCategory(Category category) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());
  }

  // 카테고리 삭제
  Future<void> deleteCategory(String id) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('categories')
        .doc(id)
        .delete();
  }
}

// CategoryRepository 프로바이더
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final uid = ref.watch(uidProvider);
  if (uid == null) {
    throw Exception('User is not logged in');
  }
  return CategoryRepository(firestore, uid);
});
