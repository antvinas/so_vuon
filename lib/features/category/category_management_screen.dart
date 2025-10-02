import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/category.dart';
import 'package:so_vuon/features/category/category_vm.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final categoryViewModel = ref.read(categoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 관리'),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showCategoryDialog(context, categoryViewModel, category: category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => categoryViewModel.deleteCategory(category.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, categoryViewModel),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, CategoryViewModel viewModel, {Category? category}) {
    final textController = TextEditingController(text: category?.name ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? '새 카테고리 추가' : '카테고리 수정'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: '카테고리 이름'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final name = textController.text;
                if (name.isNotEmpty) {
                  if (category == null) {
                    viewModel.addCategory(name);
                  } else {
                    final updatedCategory = Category(id: category.id, name: name);
                    viewModel.updateCategory(updatedCategory);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }
}
