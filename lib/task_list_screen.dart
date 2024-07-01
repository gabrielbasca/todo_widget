import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_model.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AddTodo(),
          Expanded(child: TodoListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTodoDialog();
      },
    );
  }
}

class AddTodo extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Add a new todo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                context.read<TodoModel>().addTodo(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoModel>(
      builder: (context, todoModel, child) {
        return ListView.builder(
          itemCount: todoModel.todos.length,
          itemBuilder: (context, index) {
            final todo = todoModel.todos[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => todoModel.toggleTodo(todo.id),
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => todoModel.removeTodo(todo.id),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: todo,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddTodoDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Todo'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter todo'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              context.read<TodoModel>().addTodo(_controller.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
