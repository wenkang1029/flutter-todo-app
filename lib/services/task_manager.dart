import 'package:flutter/material.dart';
import '../models/task.dart';
import 'database_helper.dart';
import 'notification_service.dart';

class TaskManager extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _databaseHelper.getAllTasks();
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final id = await _databaseHelper.insertTask(task);
      final newTask = task.copyWith(id: id);
      _tasks.add(newTask);

      // Schedule notification if reminder is set
      if (newTask.reminderTime != null) {
        await _notificationService.scheduleNotification(
          id: newTask.id!,
          title: 'Task Reminder',
          body: newTask.title,
          scheduledTime: newTask.reminderTime!,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _databaseHelper.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _databaseHelper.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);

      // Cancel notification
      await _notificationService.cancelNotification(id);

      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> searchTasks(String query) {
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            (task.description?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();
  }
}
