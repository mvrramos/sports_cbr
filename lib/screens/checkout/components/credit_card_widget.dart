import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import '../../../models/payment/credit_card.dart';
import 'card_back.dart';
import 'card_front.dart';

class CreditCardWidget extends StatefulWidget {
  CreditCardWidget(this.creditCard, {super.key});

  final CreditCard creditCard;

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(
              numberFocus,
              dateFocus,
              nameFocus,
              () {
                cardKey.currentState!.toggleCard();
                cvvFocus.requestFocus();
              },
              widget.creditCard,
            ),
            back: CardBack(
              cvvFocus,
              widget.creditCard,
            ),
          ),
          TextButton(
            onPressed: () {
              cardKey.currentState!.toggleCard();
            },
            child: const Text(
              "Virar cartão",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
