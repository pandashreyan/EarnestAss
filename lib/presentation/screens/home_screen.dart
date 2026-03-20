import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/state/auth_provider.dart' as app_auth;
import 'package:myapp/state/task_provider.dart';
import 'package:myapp/state/theme_provider.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<app_auth.AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const _TaskScreen();
  }
}

class _TaskScreen extends StatefulWidget {
  const _TaskScreen();

  @override
  State<_TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<_TaskScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.reset();
    taskProvider.fetchTasks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        taskProvider.fetchMoreTasks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.reset();
    await taskProvider.fetchTasks();
  }

  void _onSearchChanged(String query) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.setSearchQuery(query);
    taskProvider.reset();
    taskProvider.fetchTasks();
  }

  void _onFilterChanged(bool? isCompleted) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.setFilter(isCompleted);
    taskProvider.reset();
    taskProvider.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                title: const Text('Tasks'),
                floating: true,
                pinned: true,
                snap: false,
                actions: [
                  IconButton(
                    icon: Icon(themeProvider.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: 'Toggle Theme',
                  ),
                  PopupMenuButton<bool?>(
                    onSelected: _onFilterChanged,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<bool?>>[
                      const PopupMenuItem<bool?>(
                        value: null,
                        child: Text('All'),
                      ),
                      const PopupMenuItem<bool?>(
                        value: true,
                        child: Text('Completed'),
                      ),
                      const PopupMenuItem<bool?>(
                        value: false,
                        child: Text('Incomplete'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Provider.of<app_auth.AuthProvider>(context, listen: false).logout();
                    },
                  ),
                ],
                bottom: AppBar(
                  title: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          ),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ),
                ),
              ),
              (taskProvider.isLoading && taskProvider.tasks.isEmpty)
                  ? SliverFillRemaining(
                      child: Center(child: Lottie.asset('assets/lottie/loading.json')))
                  : (taskProvider.errorMessage != null && taskProvider.tasks.isEmpty)
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(taskProvider.errorMessage!),
                                ElevatedButton(
                                  onPressed: _refreshTasks,
                                  child: const Text('Retry'),
                                )
                              ],
                            ),
                          ),
                        )
                      : (taskProvider.tasks.isEmpty)
                          ? SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/lottie/empty.json', height: 200),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'No tasks found. Create a new task by tapping the + button.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index >= taskProvider.tasks.length) {
                                    return taskProvider.isLoadingMore
                                        ? Center(child: Lottie.asset('assets/lottie/loading.json'))
                                        : const SizedBox.shrink();
                                  }

                                  final task = taskProvider.tasks[index];
                                  return _TaskListItem(task: task);
                                },
                                childCount: taskProvider.tasks.length + (taskProvider.hasMore ? 1 : 0),
                              ),
                            ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTaskDialog(context, taskProvider);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                taskProvider.addTask(
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final Task task;

  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(task.description, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            final updatedTask = Task(
              id: task.id,
              title: task.title,
              description: task.description,
              isCompleted: value!,
            );
            taskProvider.updateTask(updatedTask);
          },
        ),
        onTap: () => context.go('/home/task', extra: task),
        onLongPress: () {
          taskProvider.deleteTask(task.id);
        },
      ),
    );
  }
}
