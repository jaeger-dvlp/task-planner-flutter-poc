import 'package:get/get.dart';
import 'package:task_planner_poc/services/local_db_service.dart';
import 'package:uuid/uuid.dart';
import 'package:task_planner_poc/models/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;
  final Uuid uuid = Uuid();
  final LocalDbService _dbService = Get.find<LocalDbService>();

  @override
  void onInit() {
    super.onInit();
    _loadTasksFromDb();
  }

  void _loadTasksFromDb() {
    final storedTasks = _dbService.loadTasks();
    taskList.assignAll(storedTasks);
    update();
  }

  void addTask(String title, String description) {
    final newTask = Task(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    taskList.add(newTask);
    _dbService.saveTasks(taskList);
    update();
  }

  void removeTask(String id) {
    taskList.removeWhere((task) => task.id == id);
    _dbService.saveTasks(taskList);
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
      _dbService.saveTasks(taskList);
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
      _dbService.saveTasks(taskList);
      update();
    }
  }
}
