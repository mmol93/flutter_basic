import 'package:flutter/material.dart';
import 'package:flutter_basic/ui/todo_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Architecture Playground')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Todo Page'),
            subtitle: const Text('Riverpod Notifier / AsyncNotifier example'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

