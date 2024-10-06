import 'package:flutter/material.dart';
import 'package:sportscbr/common/custom_icon_button.dart';
import 'package:sportscbr/models/item_size.dart';
import 'package:sportscbr/models/product/product.dart';
import 'package:sportscbr/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes!.isEmpty) {
          return "Insira o tamanho do produto";
        }
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tamanhos",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                CustomIconButton(Icons.add, Colors.green, () {
                  state.value!.add(ItemSize());
                  state.didChange(state.value);
                })
              ],
            ),
            Column(
              children: state.value!.map((size) {
                return EditItemSize(
                  ObjectKey(size),
                  size,
                  onRemove: () {
                    state.value!.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value!.first
                      ? () {
                          final index = state.value!.indexOf(size);
                          state.value!.remove(size);
                          state.value!.insert(index - 1, size);
                          state.didChange(state.value);
                        }
                      : () {
                          null;
                        },
                  onMoveDown: size != state.value!.last
                      ? () {
                          final index = state.value!.indexOf(size);
                          state.value!.remove(size);
                          state.value!.insert(index + 1, size);
                          state.didChange(state.value);
                        }
                      : () {
                          null;
                        },
                );
              }).toList(),
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
