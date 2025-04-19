import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;



class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key, required this.title});

  final String title;

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  /*
  File? galleryFile;
  String _recognizedText = "";
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 20,
            child: GestureDetector(
              onTap: (){
                context.push(
                    '/viewReceipt',
                    extra: galleryFile,
                );
              },
              child: galleryFile == null
                  ? const Center(child: Text('No Image Selected'))
                  : Center(child: Image.file(galleryFile!)),
            )
          ),
          Expanded(
            flex: 35,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: Text(
                    _recognizedText,
                    style: TextStyle(fontSize: 16), // Adjust font size as needed
                  ),
                ),
              )
            )
          ),
          Expanded(
              flex: 35,
              child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      child: Text(
                        _recognizedText,
                        style: TextStyle(fontSize: 16), // Adjust font size as needed
                      ),
                    ),
                  )
              )
          ),
          Expanded(
            flex: 10,
            child: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: Transform.scale(
                    scale: 1.0,
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

  Future _proccessReceiptText() async {
    if(galleryFile == null){
      return;
    }

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Read the image bytes
    final imageBytes = await galleryFile?.readAsBytes();
    final image = img.decodeImage(imageBytes!);

    // Step 1: Convert to grayscale
    final grayscale = img.grayscale(image!);

    // Step 2: Enhance contrast and brightness
    //final contrastEnhanced = _applyContrastAndBrightness(grayscale, contrast: 1.5, brightness: 20);

    // Step 3: Resize image to improve OCR results
    final resized = img.copyResize(grayscale, width: 1024);

    // Step 4: Save processed image to a temporary file
    final tempFile = File('${galleryFile?.parent.path}/temp_processed_image.jpg')
      ..writeAsBytesSync(img.encodeJpg(resized));

    // Step 5: Create InputImage from the temporary file path
    final inputImage = InputImage.fromFilePath(tempFile.path);

    // Step 6: Perform OCR
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Step 7: Update the recognized text in UI
    setState(() {
      _recognizedText = recognizedText.text.isNotEmpty ? recognizedText.text : "No text recognized";
    });

    textRecognizer.close();
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
          _proccessReceiptText();
        } else {
          ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
   */
}
