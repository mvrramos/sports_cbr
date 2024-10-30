import 'package:flutter/material.dart';
import '../../../common/custom_icon_button.dart';
import '../../../models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(Key key, this.size, {required this.onRemove, required this.onMoveUp, required this.onMoveDown}) : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: "Título",
              labelStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: const TextStyle(fontSize: 18, color: Colors.white),
            validator: (name) {
              if (name!.isEmpty) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: "Estoque",
              labelStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            validator: (stock) {
              // Pega o texto e transforma em int, se retornar null (erro)
              if (int.tryParse(stock!) == null) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            initialValue: size.price?.toString(),
            decoration: const InputDecoration(labelText: "Preço", labelStyle: TextStyle(color: Colors.white, fontSize: 18), prefixText: "R\$ ", prefixStyle: TextStyle(color: Colors.white, fontSize: 18)),
            style: const TextStyle(fontSize: 18, color: Colors.white),
            validator: (price) {
              if (num.tryParse(price!) == null) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),
        CustomIconButton(Icons.remove, Colors.red, onRemove),
        CustomIconButton(Icons.arrow_drop_up, Colors.green, onMoveUp),
        CustomIconButton(Icons.arrow_drop_down_sharp, Colors.red, onMoveDown),
      ],
    );
  }
}
