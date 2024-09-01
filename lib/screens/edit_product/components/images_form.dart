import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/product.dart';
import 'package:sportscbr/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images as Iterable),
      validator: (images) {
        if (images!.isEmpty) {
          return 'Insira ao menos uma imagem';
        }
        return null;
      },
      onSaved: (images) => product.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value!.add(file);
          state.didChange(state.value);
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                items: state.value!.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      image is String
                          ? Image.network(
                              image,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              image as File,
                              fit: BoxFit.cover,
                            ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.highlight_remove_sharp),
                          color: Colors.red,
                          onPressed: () {
                            state.value!.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()
                  ..add(Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Colors.black,
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                  onImageSelected,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.photo,
                              size: 50,
                            )),
                      )
                    ],
                  )),
                options: CarouselOptions(aspectRatio: 1),
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
          ],
        );
      },
    );
  }
}
