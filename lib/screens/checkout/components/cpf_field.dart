import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../models/user/user_manager.dart';

class CpfField extends StatelessWidget {
  const CpfField({super.key});

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CPF",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            TextFormField(
              initialValue: userManager.dataUser?.cpf,
              decoration: InputDecoration(
                hintText: "123.456.789-00",
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: (cpf) {
                if (cpf!.isEmpty)
                  return "Campo obrigatório";
                else if (!CPFValidator.isValid(cpf)) return "CPF inválido";

                return null;
              },
              onSaved: userManager.dataUser!.setCpf,
            ),
          ],
        ),
      ),
    );
  }
}
