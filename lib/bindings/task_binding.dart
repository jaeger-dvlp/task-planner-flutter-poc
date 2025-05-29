import 'package:get/get.dart';
import 'package:task_planner_poc/controllers/task_controller.dart';
import 'package:task_planner_poc/services/local_db_service.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<LocalDbService>(() => LocalDbService());
  }
}
