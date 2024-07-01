import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_model.dart';

class TaskDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Todo todo = ModalRoute.of(context)!.settings.arguments as Todo;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Status: '),
                Consumer<TodoModel>(
                  builder: (context, todoModel, child) {
                    return Checkbox(
                      value: todo.isDone,
                      onChanged: (_) {
                        todoModel.toggleTodo(todo.id);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              todo.description ?? 'No description provided.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Due Date:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              todo.dueDate != null
                  ? '${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}'
                  : 'No due date set',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Edit Task'),
                onPressed: () {
                  _showEditDialog(context, todo);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTodoDialog(todo: todo);
      },
    );
  }
}

class EditTodoDialog extends StatefulWidget {
  final Todo todo;

  EditTodoDialog({required this.todo});

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
    _selectedDate = widget.todo.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Due Date: '),
                TextButton(
                  child: Text(_selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select Date'),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              context.read<TodoModel>().updateTodo(
                    widget.todo.id,
                    _titleController.text,
                    _descriptionController.text,
                    _selectedDate,
                  );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
