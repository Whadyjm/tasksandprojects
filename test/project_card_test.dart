import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasksandprojects/models/project.dart';
import 'package:tasksandprojects/models/task.dart';
import 'package:tasksandprojects/widgets/project_card.dart';

void main() {
  testWidgets('ProjectCard muestra nombre y cantidad de tareas', (WidgetTester tester) async {

    final project = Project(
      id: '1',
      name: 'Proyecto de prueba',
      tasks: [
        Task(id: 't1', title: 'Tarea 1'),
        Task(id: 't2', title: 'Tarea 2'),
        Task(id: 't3', title: 'Tarea 3'),
      ],
    );

    bool tapped = false;
    bool edited = false;
    bool deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ProjectCard(
          project: project,
          onTap: () => tapped = true,
          onEdit: () => edited = true,
          onDelete: () => deleted = true,
        ),
      ),
    );


    expect(find.text('Proyecto de prueba'), findsOneWidget);
    expect(find.text('3 tareas'), findsOneWidget);


    await tester.tap(find.byIcon(Icons.edit));
    expect(edited, isTrue);

    await tester.tap(find.byIcon(Icons.delete));
    expect(deleted, isTrue);

    await tester.tap(find.byType(ProjectCard));
    expect(tapped, isTrue);
  });
}