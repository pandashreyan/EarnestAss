import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/repository/task_repository.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/utils/dialog_helper.dart';

class TaskProvider with ChangeNotifier {
  late final TaskRepository _taskRepository;
  late final ApiService _apiService;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _currentPage = 1;
  String? _searchQuery;
  bool? _filter;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final BuildContext context;

  TaskProvider({required this.context}) {
    _apiService = ApiService();
    _taskRepository = TaskRepository(_apiService);
    _apiService.onUnauthorized = () {
      showAppDialog(context, 'Session Expired', 'Your session has expired. Please log in again.');
    };
  }

  void _handleError(Object e) {
    if (e.toString().contains('Unauthorized')) {
      showAppDialog(context, 'Error', 'You are not authorized to perform this action.');
    } else if (e.toString().contains('Internal Server Error')) {
      showAppDialog(context, 'Error', 'An internal server error occurred. Please try again later.');
    } else {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(bool? isCompleted) {
    _filter = isCompleted;
    notifyListeners();
  }

  void reset() {
    _tasks = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _isLoadingMore = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTasks = await _taskRepository.getTasks(
        page: _currentPage,
        search: _searchQuery,
        isCompleted: _filter,
      );
      if (newTasks.isEmpty) {
        _hasMore = false;
      } else {
        _tasks.addAll(newTasks);
        _currentPage++;
      }
    } catch (e) {
      _handleError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreTasks() async {
    if (_isLoading || !_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTasks = await _taskRepository.getTasks(
        page: _currentPage,
        search: _searchQuery,
        isCompleted: _filter,
      );
      if (newTasks.isEmpty) {
        _hasMore = false;
      } else {
        _tasks.addAll(newTasks);
        _currentPage++;
      }
    } catch (e) {
      _handleError(e);
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    try {
      final newTask = await _taskRepository.createTask(title, description);
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskRepository.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }
}
