class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스토어')),
      body: const Center(child: Text('스토어 화면')),
    );
  }
}