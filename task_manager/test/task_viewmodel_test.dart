import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/viewmodel/task_view_model.dart';
import 'package:task_manager/models/task.dart';
import 'task_db_test.mocks.dart';

void main() {
  late TaskViewModel viewModel;
  late MockTaskDB mockTaskDB;

  setUp(() {
    mockTaskDB = MockTaskDB();
    viewModel = TaskViewModel(taskDB: mockTaskDB);
  });

  test('loadTasks handles DB exception gracefully', () async {
    when(
      mockTaskDB.getTaskPage(
        offset: anyNamed('offset'),
        limit: anyNamed('limit'),
      ),
    ).thenThrow(Exception('DB error'));

    try {
      await viewModel.loadMoreTasks();
    } catch (_) {
      fail('Exception should be caught inside loadMoreTasks');
    }
  });

  test('Empty task list returns empty filtered list', () {
    viewModel.setSearchQuery('');
    viewModel.setFilterStatus('All');
    expect(viewModel.tasks, isEmpty);
  });

  test('Adding a task increases the task list', () async {
    final task = Task(id: 1, title: 'Test task', isCompleted: false);
    await viewModel.addTask(task);
    expect(viewModel.tasks.length, 1);
  });

  test('addTask handles DB exception gracefully', () async {
    final task = Task(id: 1, title: 'Test Task', isCompleted: false);

    when(mockTaskDB.insertTask(task)).thenThrow(Exception('DB insert error'));

    try {
      await viewModel.addTask(task);
    } catch (_) {
      fail('Exception should be caught inside addTask');
    }
  });

  test('updateTask handles DB exception gracefully', () async {
    final task = Task(id: 1, title: 'Updated Task', isCompleted: true);

    when(mockTaskDB.updateTask(task)).thenThrow(Exception('DB update error'));

    try {
      await viewModel.updateTask(task);
    } catch (_) {
      fail('Exception should be caught inside updateTask');
    }
  });

  test('deleteTask handles DB exception gracefully', () async {
    const taskId = 1;

    when(mockTaskDB.deleteTask(taskId)).thenThrow(Exception('DB delete error'));

    try {
      await viewModel.deleteTask(taskId);
    } catch (_) {
      fail('Exception should be caught inside deleteTask');
    }
  });

  test('exportTasks handles exception gracefully', () async {
    when(mockTaskDB.getTasks()).thenAnswer(
      (_) async => [Task(id: 1, title: 'Task 1', isCompleted: false)],
    );

    try {
      await viewModel.exportTasks();
    } catch (_) {
      fail('Exception should be caught inside exportTasks');
    }
  });

  test('Filter tasks by Completed', () async {
    final task1 = Task(id: 1, title: 'Task 1', isCompleted: true);
    final task2 = Task(id: 2, title: 'Task 2', isCompleted: false);
    await viewModel.addTask(task1);
    await viewModel.addTask(task2);
    viewModel.setFilterStatus('Completed');
    final filtered = viewModel.tasks;
    expect(filtered.length, 1);
    expect(filtered.first.isCompleted, true);
  });
}
