import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notification Settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            title: Text('Theme'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to theme settings
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
