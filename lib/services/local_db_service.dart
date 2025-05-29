import "package:get_storage/get_storage.dart";
import 'package:task_planner_poc/models/task_model.dart';

class LocalDbService {
  final GetStorage _box = GetStorage();

  final String _key = "task_list";

  List<Task> loadTasks() {
    final List<dynamic> rawList = _box.read<List<dynamic>>(_key) ?? [];
    return rawList
        .map(
          (item) => Task(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            createdAt: DateTime.parse(item['createdAt']),
            isDone: item['isDone'] ?? false,
          ),
        )
        .toList();
  }

  void saveTasks(List<Task> tasks) {
    final List<Map<String, dynamic>> rawList = tasks
        .map(
          (task) => {
            "id": task.id,
            "title": task.title,
            "description": task.description,
            "createdAt": task.createdAt.toIso8601String(),
            'isDone': task.isDone,
          },
        )
        .toList();

    _box.write(_key, rawList);
  }
}
