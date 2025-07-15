import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/service/task_db.dart';
import 'package:task_manager/utils/cvs_file_export.dart';

class TaskViewModel with ChangeNotifier {
  final TaskDB _taskDB;
  final ExportFileUtils _exportService;

  TaskViewModel({required TaskDB taskDB, ExportFileUtils? exportService})
    : _taskDB = taskDB,
      _exportService = exportService ?? ExportFileUtils();

  final List<Task> _tasks = [];
  String _searchQuery = '';
  String _filterStatus = 'All';

  //Pagination
  int _page = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  String get filterStatus => _filterStatus;

  List<Task> get tasks {
    List<Task> filtered = _tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);
      final matchesStatus =
          _filterStatus == 'All' ||
          (_filterStatus == 'Completed' && task.isCompleted) ||
          (_filterStatus == 'Pending' && !task.isCompleted);
      return matchesSearch && matchesStatus;
    }).toList();
    return filtered;
  }

  Future<void> loadTasks() async {
    _tasks.clear();
    _page = 0;
    _hasMore = true;
    await loadMoreTasks();
  }

  Future<void> loadMoreTasks() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final newTasks = await TaskDB.instance.getTaskPage(
        offset: _page * _limit,
        limit: _limit,
      );

      if (newTasks.isEmpty) {
        _hasMore = false;
      } else {
        _tasks.addAll(newTasks);
        _page++;
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> toggleCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  //DB manipulation methods
  Future<void> addTask(Task task) async {
    try {
      await TaskDB.instance.insertTask(task);
      await loadTasks();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await TaskDB.instance.updateTask(task);
      await loadTasks();
    } catch (e) {
      debugPrint('Error editing task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await TaskDB.instance.deleteTask(id);
      await loadTasks();
    } catch (e) {
      debugPrint('Error removing task: $e');
    }
  }

  //write task into cvs file
  Future<File?> exportTasks() async {
    try {
      return await _exportService.exportTasksToCSV(_tasks);
    } catch (e) {
      debugPrint('Error exporting tasks: $e');
      return null;
    }
  }
}
