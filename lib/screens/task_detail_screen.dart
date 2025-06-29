import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime? _dueDate;
  late DateTime? _reminderTime;
  late TaskPriority _priority;
  late List<SubTask> _subTasks;
  final TextEditingController _subTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _reminderTime = widget.task.reminderTime;
    // Convert string priority back to enum, default to medium if not found
    _priority = TaskPriority.values.firstWhere(
      (p) => p.label == widget.task.priority,
      orElse: () => TaskPriority.medium,
    );
    _subTasks =
        []; // Initialize empty list since Task model doesn't have subTasks
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dueDate?.hour ?? 0,
          _dueDate?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    // First select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      // Then select time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _reminderTime != null
            ? TimeOfDay.fromDateTime(_reminderTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addSubTask() {
    if (_subTaskController.text.trim().isNotEmpty) {
      setState(() {
        _subTasks.add(SubTask(title: _subTaskController.text.trim()));
        _subTaskController.clear();
      });
    }
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTasks.removeAt(index);
    });
  }

  void _toggleSubTask(int index) {
    setState(() {
      _subTasks[index].isCompleted = !_subTasks[index].isCompleted;
    });
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        reminderTime: _reminderTime,
        isCompleted: widget.task.isCompleted,
        priority: _priority.label,
      );

      await _taskService.updateTask(updatedTask);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _toggleCompletion() async {
    await _taskService.toggleTaskCompletion(widget.task.id.toString());
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _taskService.deleteTask(widget.task.id.toString());
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Due date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              subtitle: Text(
                _dueDate == null
                    ? 'No date selected'
                    : DateFormat('EEE, MMM d, yyyy').format(_dueDate!),
              ),
              onTap: () => _selectDate(context),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                      },
                    )
                  : null,
            ),
            const Divider(),

            // Reminder time picker
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Reminder'),
              subtitle: Text(
                _reminderTime == null
                    ? 'No reminder set'
                    : DateFormat('EEE, MMM d, yyyy - h:mm a')
                        .format(_reminderTime!),
              ),
              onTap: () => _selectReminderTime(context),
              trailing: _reminderTime != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _reminderTime = null;
                        });
                      },
                    )
                  : null,
            ),
            const Divider(),

            // Priority selection
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Priority',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TaskPriority.values.map((priority) {
                      return ChoiceChip(
                        label: Text(priority.label),
                        selected: _priority == priority,
                        selectedColor: priority.color.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _priority == priority
                              ? priority.color
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _priority = priority;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Subtasks
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _subTaskController,
                          decoration: const InputDecoration(
                            hintText: 'Add a subtask',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _addSubTask(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addSubTask,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._subTasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final subTask = entry.value;
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        subTask.title,
                        style: TextStyle(
                          decoration: subTask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: subTask.isCompleted
                              ? Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5)
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      value: subTask.isCompleted,
                      onChanged: (_) => _toggleSubTask(index),
                      secondary: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeSubTask(index),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  widget.task.isCompleted
                      ? Icons.restart_alt
                      : Icons.check_circle,
                ),
                label: Text(
                  widget.task.isCompleted
                      ? 'Mark as Incomplete'
                      : 'Mark as Complete',
                ),
                onPressed: _toggleCompletion,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: _updateTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
