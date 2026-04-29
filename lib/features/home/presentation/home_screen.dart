import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const features = <String>[
      'Ad-free experience',
      'Unlimited content access',
      'Priority updates',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Premium unlocked',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'You now have access to all premium features.',
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
