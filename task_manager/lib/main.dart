import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/service/task_db.dart';
import 'package:task_manager/viewmodel/task_view_model.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/utils/theme_toggle.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel(taskDB: TaskDB.instance)..loadTasks()),
        ChangeNotifierProvider(create: (_) => ThemeToggle()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeToggle>(context);

    return MaterialApp(
      title: 'Administrador de Tareas',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF90CABC),
        scaffoldBackgroundColor: const Color(0xFFF3F3EC),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF90CABC)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFB5B3D7),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A18),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF4CA89F)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF847CBF),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4CA89F),
          secondary: Color(0xFF847CBF),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
