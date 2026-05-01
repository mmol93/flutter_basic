import 'package:flutter_basic/models/todo.dart';
import 'package:flutter_basic/viewmodel/todo/todo_filter_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../viewmodel/todo/todos_viewmodel.dart';

part 'filtered_todos_provider.g.dart';

@riverpod
Future<List<Todo>> filteredTodos(Ref ref) async {
  final todos = await ref.watch(todosViewModelProvider.future);
  final filter = ref.watch(todoFilterViewModelProvider);
  return applyTodoFilter(todos, filter);
}