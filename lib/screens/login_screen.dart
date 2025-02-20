import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the home screen
                GoRouter.of(context).go('/');
              },
              child: const Text('Go to Inventory'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the inventory screen
                GoRouter.of(context).go('/inventory');
              },
              child: const Text('Go to Inventory'),
            ),
          ]
        )
      ),
    );
  }
}
