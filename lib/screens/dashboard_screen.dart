import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final allTasks = projects.expand((p) => p.tasks).toList();
    final completed = allTasks.where((t) => t.completed).length;
    final pending = allTasks.length - completed;

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          Text('Total tareas: ${allTasks.length}'),
          Text('Completadas: $completed'),
          Text('Pendientes: $pending'),
        ],
      ),
    );
  }
}