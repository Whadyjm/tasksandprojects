import '../models/project.dart';
import '../models/task.dart';

class ProjectRepository {
  final List<Project> _projects = [];

  List<Project> getProjects() => _projects;

  void addProject(Project project) => _projects.add(project);

  void updateProject(Project project) {
    final idx = _projects.indexWhere((p) => p.id == project.id);
    if (idx != -1) _projects[idx] = project;
  }

  void deleteProject(String id) =>
      _projects.removeWhere((p) => p.id == id);
}