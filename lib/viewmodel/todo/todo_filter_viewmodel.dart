import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_basic/models/todo.dart';

part 'todo_filter_viewmodel.g.dart';

@riverpod
class TodoFilterViewModel extends _$TodoFilterViewModel {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;

  List<Todo> applyFilter(List<Todo> todos) {
    return todos.where((todo) {
      if (state == 'completed') {
        return todo.completed;
      }
      if (state == 'pending') {
        return !todo.completed;
      }
      return true;
    }).toList();
  }
}

