import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import '../../../models/address.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog(this.address, {super.key});

  final Address address;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
    return AlertDialog(
      title: const Text("Endereço de entrega"),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: [
        ElevatedButton(
          style: flatButtonStyle,
          onPressed: () async {
            Navigator.of(context).pop();
            await screenshotController.capture().then((Uint8List? image) async {
              await ImageGallerySaver.saveImage(image!);
            });
          },
          child: const Text("Exportar"),
        ),
      ],
    );
  }
}
