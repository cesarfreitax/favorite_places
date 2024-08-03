import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputWidget extends StatefulWidget {
  const ImageInputWidget({super.key, required this.onSelectImage,});

  final void Function(File? imageFile) onSelectImage;

  @override
  State<ImageInputWidget> createState() {
    return _ImageInputWidgetState();
  }
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  File? selectedImageFile;

  void pickImage() async {
    XFile? pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      selectedImageFile = File(pickedImage.path);
    });

    widget.onSelectImage(selectedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: pickImage,
      label: const Text('Take a Picture'),
      icon: const Icon(Icons.photo_camera),
    );

    if (selectedImageFile != null) {
      content = GestureDetector(
        onTap: pickImage,
        child: Image.file(
          selectedImageFile!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}
