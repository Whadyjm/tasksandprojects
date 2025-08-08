import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/project_provider.dart';
import 'screens/login_screen.dart';
import 'screens/projects_screen.dart';

void main() {
  runApp(const TasksAndProjectsApp());
}

class TasksAndProjectsApp extends StatelessWidget {
  const TasksAndProjectsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tasks & Projects',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            home: auth.isAuthenticated
                ? const ProjectsScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}