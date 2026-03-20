import 'package:myapp/models/task.dart';
import 'package:myapp/services/api_service.dart';

class TaskRepository {
  final ApiService _apiService;

  TaskRepository(this._apiService);

  Future<List<Task>> getTasks({int page = 1, String? search, bool? isCompleted}) async {
    final tasksData = await _apiService.getTasks(page: page, search: search, isCompleted: isCompleted);
    return tasksData.map((task) => Task.fromJson(task)).toList();
  }

  Future<Task> createTask(String title, String description) async {
    final taskData = await _apiService.createTask(title, description);
    return Task.fromJson(taskData);
  }

  Future<void> updateTask(Task task) async {
    await _apiService.updateTask(
      task.id,
      task.title,
      task.description,
      task.isCompleted,
    );
  }

  Future<void> deleteTask(String id) async {
    await _apiService.deleteTask(id);
  }
}
