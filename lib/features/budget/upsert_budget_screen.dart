import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/data/models/budget.dart';
import 'package:so_vuon/features/budget/budget_vm.dart';
import 'package:intl/intl.dart';

class UpsertBudgetScreen extends ConsumerStatefulWidget {
  final Budget? budget;
  const UpsertBudgetScreen({super.key, this.budget});

  @override
  ConsumerState<UpsertBudgetScreen> createState() => _UpsertBudgetScreenState();
}

class _UpsertBudgetScreenState extends ConsumerState<UpsertBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _totalAmountController;
  late Map<String, TextEditingController> _categoryControllers;

  @override
  void initState() {
    super.initState();
    _totalAmountController = TextEditingController(text: widget.budget?.amount.toString() ?? '');
    _categoryControllers = {
      for (var entry in widget.budget?.categoryBudgets.entries ?? {}.entries)
        entry.key: TextEditingController(text: entry.value.toString())
    };
    if (_categoryControllers.isEmpty) {
      // Add some default categories if none exist
      _categoryControllers['식비'] = TextEditingController();
      _categoryControllers['교통'] = TextEditingController();
      _categoryControllers['쇼핑'] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    for (var controller in _categoryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
      final categoryBudgets = {
        for (var entry in _categoryControllers.entries)
          if (entry.value.text.isNotEmpty)
            entry.key: double.tryParse(entry.value.text) ?? 0
      };

      final notifier = ref.read(budgetViewModelProvider.notifier);
      if (widget.budget == null) {
        notifier.saveBudget(amount: totalAmount, categoryBudgets: categoryBudgets);
      } else {
        final updatedBudget = widget.budget!.copyWith(
          amount: totalAmount,
          categoryBudgets: categoryBudgets,
        );
        notifier.updateBudget(updatedBudget);
      }
      // Pop twice if the screen is stacked (e.g., from tapping a budget item)
      if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
      }
    }
  }

  void _addCategory() {
    final TextEditingController newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 카테고리 추가'),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(hintText: '카테고리 이름'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
            TextButton(
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  setState(() {
                    _categoryControllers[newCategoryController.text] = TextEditingController();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(budgetViewModelProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: ${state.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget == null ? '새 예산 설정' : '예산 수정'),
        actions: [
          ref.watch(budgetViewModelProvider).isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : IconButton(icon: const Icon(Icons.save), onPressed: _saveBudget),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle(context, '총 예산'),
            TextFormField(
              controller: _totalAmountController,
              decoration: const InputDecoration(labelText: '월별 총 예산 금액', prefixText: '₩'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return '금액을 입력하세요';
                if (double.tryParse(value) == null) return '숫자만 입력 가능합니다';
                return null;
              },
            ),
            const Divider(height: 32),
            _buildSectionTitle(context, '카테고리별 예산'),
            ..._categoryControllers.entries.map((entry) {
              return TextFormField(
                controller: entry.value,
                decoration: InputDecoration(labelText: '${entry.key} 예산', prefixText: '₩'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              );
            }).toList(),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
              label: const Text("카테고리 추가"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
