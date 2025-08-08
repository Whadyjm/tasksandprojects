import 'package:flutter/material.dart';
import '../models/project.dart';
import '../repositories/project_repository.dart';

class ProjectProvider with ChangeNotifier {
  final ProjectRepository _repo = ProjectRepository();

  List<Project> get projects => _repo.getProjects();

  void addProject(Project project) {
    _repo.addProject(project);
    notifyListeners();
  }

  void updateProject(Project project) {
    _repo.updateProject(project);
    notifyListeners();
  }

  void deleteProject(String id) {
    _repo.deleteProject(id);
    notifyListeners();
  }
}