import 'dart:io';
import 'package:flutter/material.dart';

class ViewReceiptScreen extends StatelessWidget {
  final File? imageFile;

  const ViewReceiptScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: imageFile != null
            ? Image.file(imageFile!)
            : const Text("No image selected", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}