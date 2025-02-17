import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'App Logo - Screen number 2',
            ),
            Text(
                'This is a test'
            ),
          ],
        ),
      ),
    );
  }
}
