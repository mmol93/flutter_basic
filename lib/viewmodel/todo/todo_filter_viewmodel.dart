import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_basic/models/todo.dart';

part 'todo_filter_viewmodel.g.dart';

enum TodoFilter { all, completed, pending }

@riverpod
class TodoFilterViewModel extends _$TodoFilterViewModel {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) => state = filter;
}

List<Todo> applyTodoFilter(List<Todo> todos, TodoFilter filter) {
  return todos.where((todo) {
    if (filter == TodoFilter.completed) {
      return todo.completed;
    }
    if (filter == TodoFilter.pending) {
      return !todo.completed;
    }
    return true;
  }).toList();
}
