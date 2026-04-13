import 'package:go_router/go_router.dart';
import 'package:task_list/lista.dart';
import 'package:task_list/login.dart';
import 'package:task_list/novo.dart';
import 'package:task_list/registro.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage()
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage()
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => ListaPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => NewTaskPage()
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return NewTaskPage(taskId: id);
          },
        ),
      ]  
    ),
  ],
);
