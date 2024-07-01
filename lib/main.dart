import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_model.dart';
import 'task_list_screen.dart';
import 'task_detail_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListScreen(),
        '/detail': (context) => TaskDetailScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
