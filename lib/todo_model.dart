import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isDone = false,
  });
}

class TodoModel extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title, {String? description, DateTime? dueDate}) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      dueDate: dueDate,
    );
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      _todos[todoIndex].isDone = !_todos[todoIndex].isDone;
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void updateTodo(
      String id, String title, String? description, DateTime? dueDate) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = Todo(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        isDone: _todos[index].isDone,
      );
      notifyListeners();
    }
  }

  List<Todo> getPendingTodos() {
    return _todos.where((todo) => !todo.isDone).toList();
  }

  List<Todo> getCompletedTodos() {
    return _todos.where((todo) => todo.isDone).toList();
  }

  List<Todo> getTodosForDate(DateTime date) {
    return _todos
        .where((todo) =>
            todo.dueDate != null &&
            todo.dueDate!.year == date.year &&
            todo.dueDate!.month == date.month &&
            todo.dueDate!.day == date.day)
        .toList();
  }

  void clearCompletedTodos() {
    _todos.removeWhere((todo) => todo.isDone);
    notifyListeners();
  }

  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isDone).length;
  int get pendingTodos => _todos.where((todo) => !todo.isDone).length;
}
