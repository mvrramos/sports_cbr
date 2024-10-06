import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  CardTextField({
    this.title,
    this.hint,
    this.type,
    this.inputFormatters,
    this.maxLenght,
    this.validator,
    this.bold = false,
    this.textAlign,
    this.focusNode,
    this.onSubmitted,
    this.onSaved,
    super.key,
  }) : textInputAction = onSubmitted == null ? TextInputAction.none : TextInputAction.next;

  final String? title;
  final bool? bold;
  final String? hint;
  final TextInputType? type;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final int? maxLenght;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Row(
                  children: [
                    Text(
                      title!,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                    if (state.hasError)
                      Text(
                        "Campo inválido",
                        style: TextStyle(color: Colors.red, fontSize: 9),
                      )
                  ],
                ),
              TextFormField(
                style: TextStyle(
                  color: title == null && state.hasError ? Colors.red : Colors.white,
                  fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.w500,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title == null && state.hasError ? Colors.red : Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    counterText: ''),
                keyboardType: type,
                inputFormatters: inputFormatters,
                onChanged: (text) {
                  state.didChange(text);
                },
                maxLength: maxLenght,
                textAlign: textAlign ?? TextAlign.start,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                textInputAction: textInputAction,
              )
            ],
          ),
        );
      },
    );
  }
}
