import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_planner_poc/controllers/task_controller.dart';
import 'package:task_planner_poc/models/task_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _removeTaskDialog(BuildContext ctx, String taskId, String taskTitle) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Delete Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete "$taskTitle" task?',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final controller = Get.find<TaskController>();
              controller.removeTask(taskId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext ctx, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Task Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              final newDesc = descController.text.trim();

              if (newTitle.isNotEmpty && newDesc.isNotEmpty) {
                final controller = Get.find<TaskController>();
                controller.updateTask(task.id, newTitle, newDesc);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext ctx) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Task Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              if (title.isNotEmpty && desc.isNotEmpty) {
                final controller = Get.find<TaskController>();
                controller.addTask(title, desc);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final taskController = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Task Planner"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GetBuilder<TaskController>(
          builder: (_) {
            if (taskController.taskList.isEmpty) {
              return const Center(child: Text("No tasks yet."));
            }

            return ListView.builder(
              itemCount: taskController.taskList.length,
              itemBuilder: (context, index) {
                final task = taskController.taskList[index];
                return Card(
                  child: ListTile(
                    onLongPress: () {
                      _showEditTaskDialog(ctx, task);
                    },
                    leading: IconButton(
                      onPressed: () {
                        taskController.toggleDone(task.id);
                      },
                      icon: Icon(
                        task.isDone
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        Text(
                          'Created At :${DateFormat('dd.MM.yyyy - HH:mm').format(task.createdAt)} ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _removeTaskDialog(ctx, task.id, task.title);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            _showEditTaskDialog(ctx, task);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(ctx);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
