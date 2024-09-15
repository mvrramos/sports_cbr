import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/product.dart';
import 'package:sportscbr/models/product_manager.dart';
import 'package:sportscbr/screens/edit_product/components/images_form.dart';
import 'package:sportscbr/screens/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product? p, {super.key})
      : editing = p != null,
        product = p?.clone() ?? Product();
  final Product product;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final bool editing;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(editing ? "Editar produto" : "Cadastrar produto"),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                onPressed: () {
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete),
              )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name ?? '',
                      decoration: const InputDecoration(hintText: "Título", border: InputBorder.none),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      validator: (name) {
                        if (name!.isEmpty) {
                          return "Insira o título do produto";
                        }
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "A partir de",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                    const Text(
                      //TODO Alterar valor aqui
                      "R\$...",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        "Descrição",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description ?? '',
                      decoration: const InputDecoration(hintText: "Descrição", border: InputBorder.none),
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      validator: (desc) {
                        if (desc!.isEmpty) {
                          return "Insira a descrição do produto";
                        }
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      await product.save();

                                      context.read<ProductManager>().update(product);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(100, 73, 5, 182),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: product.loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Salvar",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
