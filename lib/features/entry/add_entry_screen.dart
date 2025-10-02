import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 샘플 카테고리 데이터
final List<Map<String, dynamic>> sampleCategories = [
  {'name': '식비', 'icon': Icons.restaurant},
  {'name': '교통', 'icon': Icons.directions_bus},
  {'name': '쇼핑', 'icon': Icons.shopping_bag},
  {'name': '문화생활', 'icon': Icons.movie},
  {'name': '기타', 'icon': Icons.more_horiz},
];

// 지출 입력 화면의 상태를 관리하는 StateNotifier
class AddEntryState {
  final String amount;
  final String? selectedCategory;

  AddEntryState({this.amount = '0', this.selectedCategory});

  AddEntryState copyWith({String? amount, String? selectedCategory}) {
    return AddEntryState(
      amount: amount ?? this.amount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

final addEntryProvider = StateNotifierProvider<AddEntryNotifier, AddEntryState>((ref) {
  return AddEntryNotifier();
});

class AddEntryNotifier extends StateNotifier<AddEntryState> {
  AddEntryNotifier() : super(AddEntryState());

  void onNumberPressed(String value) {
    if (state.amount.length > 9) return; // 금액 길이 제한

    setState(() {
      if (state.amount == '0') {
        state = state.copyWith(amount: value);
      } else {
        state = state.copyWith(amount: state.amount + value);
      }
    });
  }

  void onBackspacePressed() {
    setState(() {
      if (state.amount.length > 1) {
        state = state.copyWith(amount: state.amount.substring(0, state.amount.length - 1));
      } else {
        state = state.copyWith(amount: '0');
      }
    });
  }

  void selectCategory(String category) {
    setState(() {
      state = state.copyWith(selectedCategory: category);
    });
  }

  void reset() {
    state = AddEntryState();
  }
}

class AddEntryScreen extends ConsumerWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addEntryProvider);
    final notifier = ref.read(addEntryProvider.notifier);
    final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

    return Scaffold(
      appBar: AppBar(
        title: const Text('지출 기록'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            notifier.reset(); // 상태 초기화
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          // 금액 표시 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            alignment: Alignment.centerRight,
            child: Text(
              currencyFormat.format(double.parse(state.amount)),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // 카테고리 선택 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: sampleCategories.map((category) {
                final bool isSelected = state.selectedCategory == category['name'];
                return ChoiceChip(
                  label: Text(category['name']!),
                  avatar: Icon(category['icon'], color: isSelected ? Colors.white : null),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      notifier.selectCategory(category['name']!);
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                );
              }).toList(),
            ),
          ),

          const Spacer(),

          // 숫자 키패드
          _buildKeypad(context, notifier),

          // 저장 버튼
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
                  ),
                  onPressed: (state.selectedCategory != null && state.amount != '0')
                      ? () {
                          // TODO: 저장 로직 구현 (Firebase 연동)
                          print('저장: ${state.amount}, 카테고리: ${state.selectedCategory}');
                          notifier.reset(); // 상태 초기화
                          context.pop(); // 화면 닫기
                        }
                      : null, // 조건 미충족 시 비활성화
                  child: const Text('저장'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context, AddEntryNotifier notifier) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0, // 버튼의 가로/세로 비율
      children: List.generate(12, (index) {
        if (index == 9) {
          return const SizedBox.shrink(); // '00' 버튼 (사용 안 함)
        } else if (index == 11) {
          // 백스페이스 버튼
          return InkWell(
            onTap: notifier.onBackspacePressed,
            child: const Center(child: Icon(Icons.backspace_outlined)),
          );
        } else {
          // 숫자 버튼 (1-9, 0)
          final number = index == 10 ? '0' : (index + 1).toString();
          return InkWell(
            onTap: () => notifier.onNumberPressed(number),
            child: Center(
              child: Text(number, style: Theme.of(context).textTheme.headlineSmall),
            ),
          );
        }
      }),
    );
  }
}
