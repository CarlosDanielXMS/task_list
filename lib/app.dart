import 'package:flutter/material.dart';
import 'package:task_list/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Task List",
      routerConfig: router,
    );
  }
}