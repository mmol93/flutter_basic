import 'package:flutter/material.dart';
import 'package:flutter_basic/viewmodel/todo/todo_filter_viewmodel.dart';
import 'package:flutter_basic/providers/todo/filtered_todos_provider.dart';
import 'package:flutter_basic/viewmodel/todo/todos_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod UI Demo')),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final currentFilter = ref.watch(todoFilterViewModelProvider);
              return SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('All')),
                  ButtonSegment(value: 'completed', label: Text('Completed')),
                  ButtonSegment(value: 'pending', label: Text('Pending')),
                ],
                selected: {currentFilter},
                onSelectionChanged: (set) =>
                    ref.read(todoFilterViewModelProvider.notifier).setFilter(set.first),
              );
            },
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final filteredTodos = ref.watch(filteredTodosProvider);
                return filteredTodos.when(
                  data: (todos) => ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        leading: Consumer(
                          builder: (context, ref, child) {
                            final isCompleted = ref.watch(
                              todosViewModelProvider.select((state) {
                                return state.valueOrNull
                                        ?.firstWhere((t) => t.id == todo.id)
                                        .completed ??
                                    false;
                              }),
                            );
                            return Checkbox(
                              value: isCompleted,
                              onChanged: (_) =>
                                  ref.read(todosViewModelProvider.notifier).toggle(todo.id),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () async {
              final controller = TextEditingController();
              final title = await showDialog<String>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Add Todo'),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Enter a todo'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );

              final trimmed = title?.trim() ?? '';
              if (trimmed.isNotEmpty) {
                await ref.read(todosViewModelProvider.notifier).addTodo(trimmed);
              }
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}


