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
          // パターン④: Consumerの境界を分離し、上部フィルターUIだけが部分更新されるように構成。
          // パターン④: selectでフィルター状態のみを購読し、不要なリビルドを削減。
          Consumer(
            builder: (context, ref, child) {
              final currentFilter = ref.watch(
                todoFilterViewModelProvider.select((filter) => filter),
              );
              return SegmentedButton<TodoFilter>(
                segments: const [
                  ButtonSegment(value: TodoFilter.all, label: Text('All')),
                  ButtonSegment(
                    value: TodoFilter.completed,
                    label: Text('Completed'),
                  ),
                  ButtonSegment(value: TodoFilter.pending, label: Text('Pending')),
                ],
                selected: {currentFilter},
                onSelectionChanged: (set) =>
                    // パターン①: NotifierProviderのnotifierをreadして、同期状態変更動作(setFilter)を実行。
                    ref.read(todoFilterViewModelProvider.notifier).setFilter(set.first),
              );
            },
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // パターン③: 派生Provider(filteredTodosProvider)をwatchすると値が変更された時のみリビルドされる。
                final filteredTodos = ref.watch(filteredTodosProvider);
                // パターン②: Async状態(data/error/loading)をwhenで自動分岐レンダリング。
                return filteredTodos.when(
                  data: (todos) => ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (_) =>
                              // パターン②: AsyncNotifierProviderの非同期アクション(toggle)を呼び出し。
                              ref.read(todosViewModelProvider.notifier).toggle(todo.id),
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
                // パターン②: AsyncNotifierProviderの非同期アクション(addTodo)でデータを更新。
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
