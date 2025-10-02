import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:so_vuon/data/models/category.dart';
import 'package:so_vuon/data/models/entry.dart';
import 'package:so_vuon/features/category/category_vm.dart';
import 'package:so_vuon/features/entry/entry_vm.dart';

class AddEntrySheet extends ConsumerStatefulWidget {
  const AddEntrySheet({super.key});

  @override
  ConsumerState<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends ConsumerState<AddEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final type = _isExpense ? EntryType.expense : EntryType.income;
      final description = _descriptionController.text;

      ref.read(entryViewModelProvider.notifier).addEntry(
        amount: amount,
        type: type,
        category: _selectedCategory!,
        description: description,
        date: _selectedDate,
      );
      
      Navigator.pop(context); // Close the bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    
    // Listen to the view model state for loading/error handling
    ref.listen<AsyncValue>(
      entryViewModelProvider, 
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류가 발생했습니다: $error')),
          );
        },
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, 
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text('새로운 내역 추가', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment<bool>(value: true, label: Text('지출'), icon: Icon(Icons.remove)),
                ButtonSegment<bool>(value: false, label: Text('수입'), icon: Icon(Icons.add)),
              ],
              selected: {_isExpense},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isExpense = newSelection.first;
                  _selectedCategory = null;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '금액',
                border: OutlineInputBorder(),
                prefixText: '₩ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '금액을 입력해주세요.';
                if (double.tryParse(value) == null) return '숫자만 입력해주세요.';
                return null;
              },
            ),
            const SizedBox(height: 16),

            categoriesAsync.when(
              data: (categories) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(value: category.name, child: Text(category.name));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  validator: (value) => value == null ? '카테고리를 선택해주세요.' : null,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('카테고리를 불러올 수 없습니다.')),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '내용 (선택 사항)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '날짜: ${DateFormat('yyyy. MM. dd').format(_selectedDate)}',
                  style: theme.textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('날짜 변경'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: _submit,
              child: const Text('저장하기'),
            ),
            const SizedBox(height: 24),
          ],
        ),),
    );
  }
}
