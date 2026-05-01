import 'package:flutter_basic/models/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todos_viewmodel.g.dart';

@riverpod
class TodosViewModel extends _$TodosViewModel {
  @override
  Future<List<Todo>> build() async {
    // ロードするように見せるために、1秒の遅延を追加
    await Future.delayed(const Duration(seconds: 1));
    return [
      Todo(id: 1, title: 'Study Flutter', completed: false),
      Todo(id: 2, title: 'Grocery Shopping', completed: true),
    ];
  }

  Future<void> addTodo(String title) async {
    // 現在のデータを取得
    final current = await future;
    final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, title: title);
    // 追加したデータを画面の元になるデータ（=state）にセット
    state = AsyncData([...current, newTodo]);
  }

  Future<void> toggle(int id) async {
    final current = await future;
    state = AsyncData(
      current.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList(),
    );
  }
}


