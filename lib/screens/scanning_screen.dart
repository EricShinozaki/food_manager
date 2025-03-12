import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key, required this.title});

  final String title;

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  File? galleryFile;
  final picker = ImagePicker();
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
            flex: 80,
            child: Text(""),
          ),
          Expanded(
            flex: 20,
            child: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: Transform.scale(
                    scale: 1.5,
                    child: FilledButton.tonal(
                      onPressed: () {
                        _showPicker(context: context);
                      },
                      child: Text("Select an image"),
                    ),
                  ),
                );
              }
            )
          ),
        ],
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
      ImageSource img,
      ) async {
    // pick image from gallary
    final pickedFile = await picker.pickImage(source: img);
    // store it in a valid variable
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          // store that in global variable galleryFile in the form of File
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
