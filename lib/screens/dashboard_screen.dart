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

    double completedPercent = allTasks.isEmpty ? 0 : completed / allTasks.length;
    double pendingPercent = allTasks.isEmpty ? 0 : pending / allTasks.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'Resumen de Tareas',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            _StatBar(
              label: 'Completadas',
              value: completed,
              total: allTasks.length,
              color: Colors.green,
              percent: completedPercent,
            ),
            const SizedBox(height: 24),
            _StatBar(
              label: 'Pendientes',
              value: pending,
              total: allTasks.length,
              color: Colors.orange,
              percent: pendingPercent,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Total de Proyectos'),
                trailing: Text('${projects.length}'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Total de Tareas'),
                trailing: Text('${allTasks.length}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  final double percent;

  const _StatBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value de $total'),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 18,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}