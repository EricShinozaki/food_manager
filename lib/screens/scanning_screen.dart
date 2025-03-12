import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      body: Column(
        children: [
          Expanded(
            flex: 92,
            child: Center(

            )
          ),
          Expanded(
            flex: 8,
            child: Container(
              margin: const EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 15),
              child: Center(
                child: FilledButton.tonal(
                  onPressed: () {
                    context.go('/scanning/takePicture');
                  },
                  child: const Text("Scan a receipt"),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
