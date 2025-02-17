import 'package:flutter/material.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key, required this.title});

  final String title;

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
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
