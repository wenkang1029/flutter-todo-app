import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'notification_service.dart';

class TaskService {
  static const String _tasksKey = 'tasks';
  final NotificationService _notificationService = NotificationService();

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson
        .map((taskJson) => Task.fromMap(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await _saveTasks(tasks);

    if (task.reminderTime != null) {
      await _notificationService.scheduleTaskReminder(task);
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index != -1) {
      // Cancel existing notification if any
      await _notificationService.cancelTaskReminder(tasks[index]);

      tasks[index] = updatedTask;
      await _saveTasks(tasks);

      // Schedule new notification if needed
      if (updatedTask.reminderTime != null) {
        await _notificationService.scheduleTaskReminder(updatedTask);
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    final taskToRemove = tasks.firstWhere((task) => task.id == taskId);

    // Cancel notification for the task being deleted
    await _notificationService.cancelTaskReminder(taskToRemove);

    tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks(tasks);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((task) => task.id.toString() == taskId);

    if (index != -1) {
      final task = tasks[index];
      tasks[index] = task.copyWith(isCompleted: !task.isCompleted);

      // Cancel notification if completed
      if (tasks[index].isCompleted) {
        await _notificationService.cancelTaskReminder(tasks[index]);
      }

      await _saveTasks(tasks);
    }
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }
}
