import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/viewmodel/task_view_model.dart';
import 'package:task_manager/utils/theme_toggle.dart';
import 'package:task_manager/widgets/task_tile.dart';
import 'package:task_manager/screens/create_task_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        final viewModel = Provider.of<TaskViewModel>(context, listen: false);
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !viewModel.isLoadingMore &&
            viewModel.hasMore) {
          viewModel.loadMoreTasks();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final themeToggle = Provider.of<ThemeToggle>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final tasks = taskViewModel.tasks;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: Icon(
              themeToggle.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: themeToggle.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final file = await taskViewModel.exportTasks();
              if (file == null) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error al exportar las tareas.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              await Share.shareXFiles([XFile(file.path)]);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar tarea...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                taskViewModel.setSearchQuery(query);
              },
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text('Filtro:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: taskViewModel.filterStatus,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('Todas')),
                    DropdownMenuItem(
                      value: 'Completed',
                      child: Text('Completadas'),
                    ),
                    DropdownMenuItem(
                      value: 'Pending',
                      child: Text('Pendientes'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) taskViewModel.setFilterStatus(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset('assets/images/listImage.jpg'),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Bienvenido a tu administrador de tareas.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          tasks.length + (taskViewModel.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < tasks.length) {
                          return TaskTile(task: tasks[index]);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),

      // Add task button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
          taskViewModel.loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
