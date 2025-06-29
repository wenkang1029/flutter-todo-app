import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onToggle,
  });

  // Helper method to get TaskPriority from string
  TaskPriority get _taskPriority {
    return TaskPriority.values.firstWhere(
      (p) => p.label == task.priority,
      orElse: () => TaskPriority.medium,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id?.toString() ?? ''),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check_circle, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onToggle();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text(
                  "Are you sure you want to delete this task?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete"),
                  ),
                ],
              );
            },
          );
        } else {
          onToggle();
          return false; // Don't actually dismiss, we'll just toggle the state
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 2,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: _taskPriority.color.withOpacity(0.2),
            child: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: _taskPriority.color,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted
                  ? Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description?.isNotEmpty == true)
                Text(
                  task.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              // Note: Removed subTasks reference since Task model doesn't have it
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.reminderTime != null)
                Icon(
                  Icons.notifications_active,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _taskPriority.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _taskPriority.label,
                  style: TextStyle(fontSize: 12, color: _taskPriority.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
