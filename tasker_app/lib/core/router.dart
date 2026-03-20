import 'package:go_router/go_router.dart';
import 'package:tasker_app/presentation/screens/auth/login_screen.dart';
import 'package:tasker_app/presentation/screens/auth/register_screen.dart';
import 'package:tasker_app/presentation/screens/task/task_list_screen.dart';
import 'package:tasker_app/presentation/screens/welcome_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const TaskListScreen(),
    ),
  ],
);
