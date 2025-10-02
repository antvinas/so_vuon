import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/category.dart';
import 'package:so_vuon/data/repositories/category_repository.dart';

// 카테고리 리스트 스트림 프로바이더
final categoriesStreamProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return categoryRepository.getCategories();
});

class CategoryViewModel {
  final CategoryRepository _categoryRepository;

  CategoryViewModel(this._categoryRepository);

  Future<void> addCategory(String name) {
    return _categoryRepository.addCategory(name);
  }

  Future<void> updateCategory(Category category) {
    return _categoryRepository.updateCategory(category);
  }

  Future<void> deleteCategory(String id) {
    return _categoryRepository.deleteCategory(id);
  }
}

// CategoryViewModel 프로바이더
final categoryViewModelProvider = Provider<CategoryViewModel>((ref) {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return CategoryViewModel(categoryRepository);
});
