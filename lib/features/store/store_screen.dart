import 'package:flutter/material.dart';

// 샘플 아이템 데이터
final List<Map<String, dynamic>> storeItems = [
  {'name': '벚꽃 테마', 'price': 500, 'image': 'assets/images/logo.png'}, // 이미지는 나중에 교체
  {'name': '가을 단풍 테마', 'price': 500, 'image': 'assets/images/logo.png'},
  {'name': '특별한 씨앗', 'price': 100, 'image': 'assets/images/logo.png'},
  {'name': '황금 물뿌리개', 'price': 200, 'image': 'assets/images/logo.png'},
];

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스토어')),
      body: Column(
        children: [
          // 보유 포인트 표시
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text('1,200 P', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),

          // 아이템 그리드
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2열
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8, // 아이템 비율
              ),
              itemCount: storeItems.length,
              itemBuilder: (context, index) {
                final item = storeItems[index];
                return StoreItemCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 스토어 아이템을 나타내는 카드 위젯
class StoreItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const StoreItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // 이미지 오버플로우 방지
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 아이템 이미지
          Expanded(
            child: Image.asset(item['image'], fit: BoxFit.cover),
          ),

          // 아이템 정보 및 구매 버튼
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: Theme.of(context).textTheme.titleSmall),
                Text('${item['price']} P', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.amber[800])),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // 구매 로직 (추후 구현)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} 구매 완료!')),
                      );
                    },
                    child: const Text('구매'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
