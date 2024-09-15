import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet(this.onImageSelected, {super.key});

  final ImagePicker picker = ImagePicker();
  final Function(File) onImageSelected;

  Future<void> editImage(String path, BuildContext context) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper.platform.cropImage(sourcePath: path);
      if (croppedFile != null) {
        final File imageFile = File(croppedFile.path);
        onImageSelected(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao editar imagem: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final XFile? file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  await editImage(file.path, context);
                  Navigator.of(context).pop(); // Fechar o BottomSheet
                }
              },
              child: const Text("Câmera"),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  await editImage(file.path, context);
                  Navigator.of(context).pop(); // Fechar o BottomSheet
                }
              },
              child: const Text("Galeria"),
            ),
          ],
        );
      },
      onClosing: () {},
    );
  }
}
