import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksandprojects/providers/auth_provider.dart';
import 'package:tasksandprojects/screens/dashboard_screen.dart';
import 'package:tasksandprojects/screens/login_screen.dart';
import 'package:tasksandprojects/screens/project_detail_screen.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';

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
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DashboardScreen();
                  })),
              icon: const Icon(Icons.dashboard_customize_rounded)),
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
    ? const Center(child: Text('No hay proyectos'))
    : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: projects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, i) => ProjectCard(
                  project: projects[i],
                  onTap: () => _navigateToProjectDetail(context, projects[i]),
                  onEdit: () => _showProjectDialog(context, project: projects[i]),
                  onDelete: () => _confirmDelete(context, projects[i]),
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
