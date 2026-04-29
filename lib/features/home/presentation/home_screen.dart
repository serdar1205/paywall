import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const features = <String>[
      'Без рекламы',
      'Неограниченный доступ к контенту',
      'Приоритетные обновления',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Премиум активирован',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Теперь у вас есть доступ ко всем премиум-функциям.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          for (final feature in features)
            Card(
              child: ListTile(
                leading: const Icon(Icons.check),
                title: Text(feature),
              ),
            ),
        ],
      ),
    );
  }
}
