import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/payment/credit_card.dart';
import 'card_text_field.dart';

class CardBack extends StatelessWidget {
  CardBack(this.cvvFocus, this.creditCard, {super.key});

  final FocusNode cvvFocus;
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
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: EdgeInsets.only(left: 12),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: CardTextField(
                      hint: '123',
                      maxLenght: 3,
                      type: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (cvv) {
                        if (cvv!.length != 3) return "Campo inválido";
                        return null;
                      },
                      textAlign: TextAlign.end,
                      focusNode: cvvFocus,
                      onSaved: (cvv) => creditCard.setCvv(cvv!),
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
