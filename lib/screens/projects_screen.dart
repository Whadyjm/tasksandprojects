import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksandprojects/providers/auth_provider.dart';
import 'package:tasksandprojects/screens/login_screen.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  void _showProjectDialog(BuildContext context, {Project? project}) {
    final formKey = GlobalKey<FormState>();
    String name = project?.name ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(project == null ? 'Nuevo Proyecto' : 'Editar Proyecto'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: name,
            decoration: const InputDecoration(labelText: 'Nombre del proyecto'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingrese un nombre' : null,
            onSaved: (v) => name = v!.trim(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final provider =
                    Provider.of<ProjectProvider>(context, listen: false);
                if (project == null) {
                  provider.addProject(
                    Project(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      tasks: [],
                    ),
                  );
                } else {
                  provider.updateProject(
                    Project(
                      id: project.id,
                      name: name,
                      tasks: project.tasks,
                    ),
                  );
                }
                Navigator.of(ctx).pop();
              }
            },
            child: Text(project == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content: Text('¿Seguro que deseas eliminar "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ProjectProvider>(context, listen: false)
                  .deleteProject(project.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showTaskDialog(BuildContext context, Project project, {Task? task}) {
    final formKey = GlobalKey<FormState>();
    String title = task?.title ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(task == null ? 'Nueva Tarea' : 'Editar Tarea'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: title,
            decoration: const InputDecoration(labelText: 'Título de la tarea'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingrese un título' : null,
            onSaved: (v) => title = v!.trim(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final provider =
                    Provider.of<ProjectProvider>(context, listen: false);
                final updatedTasks = List<Task>.from(project.tasks);
                if (task == null) {
                  updatedTasks.add(Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                  ));
                } else {
                  final idx = updatedTasks.indexWhere((t) => t.id == task.id);
                  if (idx != -1) {
                    updatedTasks[idx] = Task(
                      id: task.id,
                      title: title,
                      completed: task.completed,
                    );
                  }
                }
                provider.updateProject(Project(
                  id: project.id,
                  name: project.name,
                  tasks: updatedTasks,
                ));
                Navigator.of(ctx).pop();
              }
            },
            child: Text(task == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _navigateToProjectDetail(BuildContext context, Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(projectId: project.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        actions: [
          IconButton(
              onPressed: () {
                AuthProvider().logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: projects.isEmpty
          ? const Center(child: Text('No hay proyectos.'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(projects[i].name),
                onTap: () => _navigateToProjectDetail(context, projects[i]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showProjectDialog(context, project: projects[i]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, projects[i]),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectDialog(context),
        tooltip: 'Nuevo Proyecto',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.projects.firstWhere((p) => p.id == projectId,
        orElse: () => Project(id: '', name: '', tasks: []));

    if (project.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Proyecto'),
        ),
        body: const Center(child: Text('Proyecto no encontrado')),
      );
    }

    void _confirmDeleteTask(BuildContext context, Project project, Task task) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: Text('¿Seguro que deseas eliminar "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<ProjectProvider>(context, listen: false);
                final updatedTasks =
                    project.tasks.where((t) => t.id != task.id).toList();
                provider.updateProject(Project(
                  id: project.id,
                  name: project.name,
                  tasks: updatedTasks,
                ));
                Navigator.of(ctx).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: project.tasks.isEmpty
          ? const Center(child: Text('No hay tareas.'))
          : ListView.builder(
              itemCount: project.tasks.length,
              itemBuilder: (_, i) {
                final task = project.tasks[i];
                return ListTile(
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (val) {
                      final updatedTasks = List<Task>.from(project.tasks);
                      updatedTasks[i] = Task(
                        id: task.id,
                        title: task.title,
                        completed: val ?? false,
                      );
                      provider.updateProject(Project(
                        id: project.id,
                        name: project.name,
                        tasks: updatedTasks,
                      ));
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Editar Tarea'),
                              content: TextFormField(
                                initialValue: task.title,
                                decoration: const InputDecoration(
                                    labelText: 'Título de la tarea'),
                                onFieldSubmitted: (value) {
                                  final updatedTasks =
                                      List<Task>.from(project.tasks);
                                  updatedTasks[i] = Task(
                                    id: task.id,
                                    title: value,
                                    completed: task.completed,
                                  );
                                  provider.updateProject(Project(
                                    id: project.id,
                                    name: project.name,
                                    tasks: updatedTasks,
                                  ));
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancelar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeleteTask(context, project, task);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final formKey = GlobalKey<FormState>();
          String title = '';
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Nueva Tarea'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Título de la tarea'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese un título' : null,
                  onSaved: (v) => title = v!.trim(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final updatedTasks = List<Task>.from(project.tasks)
                        ..add(Task(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: title,
                        ));
                      provider.updateProject(Project(
                        id: project.id,
                        name: project.name,
                        tasks: updatedTasks,
                      ));
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Crear'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Nueva Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
