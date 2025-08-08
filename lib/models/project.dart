import 'package:tasksandprojects/models/task.dart';

class Project {
  final String id;
  String name;
  List<Task> tasks;

  Project({required this.id, required this.name, required this.tasks});
}