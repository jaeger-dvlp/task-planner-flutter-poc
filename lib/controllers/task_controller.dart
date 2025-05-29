import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:task_planner_poc/models/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;
  final Uuid uuid = Uuid();

  void addTask(String title, String description) {
    final newTask = Task(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    taskList.add(newTask);
    update();
  }

  void removeTask(String id) {
    taskList.removeWhere((task) => task.id == id);
    update();
  }

  void updateTask(String id, String newTitle, String newDesc) {
    final index = taskList.indexWhere((task) => task.id == id);
    if (index! != -1) {
      final updatedTask = taskList[index].copyWith(
        title: newTitle,
        description: newDesc,
      );

      taskList[index] = updatedTask;
      update();
    }
  }

  void toggleDone(String id) {
    final index = taskList.indexWhere((task) => task.id == id);

    if (index != -1) {
      final updatedTask = taskList[index].copyWith(
        isDone: !taskList[index].isDone,
      );
      taskList[index] = updatedTask;
      update();
    }
  }
}
