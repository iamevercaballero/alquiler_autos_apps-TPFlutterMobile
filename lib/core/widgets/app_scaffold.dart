import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;
  final Widget? floatingActionButton; // <-- NUEVO

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.floatingActionButton, // <-- NUEVO
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton, // <-- NUEVO
    );
  }
}
