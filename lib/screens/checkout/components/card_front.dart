import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../models/payment/credit_card.dart';
import 'card_text_field.dart';

class CardFront extends StatelessWidget {
  CardFront(this.numberFocus, this.dateFocus, this.nameFocus, this.finished, this.creditCard, {super.key});

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
    mask: '!#/####',
    filter: {
      '#': RegExp('[0-9]'),
      '!': RegExp('[0-1]')
    },
  );

  final VoidCallback finished;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: Color(0xFF1B4B52),
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon(Icons.credit_card),
                  CardTextField(
                    title: "Número",
                    hint: "0000 0000 0000 0000",
                    type: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (numberCard) {
                      // List<CreditCardType> brands = detectCCType(numberCard!);

                      if (numberCard!.length != 19) {
                        return "Campo inválido";
                      }

                      return null;
                    },
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                    focusNode: numberFocus,
                    onSaved: (numberCard) => creditCard.setNumber(numberCard!),
                  ),
                  CardTextField(
                    title: "Validade",
                    hint: "12/3456",
                    type: TextInputType.number,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      dateFormatter,
                    ],
                    validator: (date) {
                      if (date!.length < 7) return "Campo inválido";
                      return null;
                    },
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                    focusNode: dateFocus,
                    onSaved: (date) => creditCard.setExpirationDate(date!),
                  ),
                  CardTextField(
                    title: "Titular",
                    hint: "Insira o seu nome",
                    type: TextInputType.text,
                    bold: true,
                    validator: (name) {
                      if (name!.isEmpty) return "Campo inválido";
                      return null;
                    },
                    onSubmitted: (_) {
                      finished();
                    },
                    focusNode: nameFocus,
                    onSaved: (name) => creditCard.setHolder(name!),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
