import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'sized_box_hw.dart';
import 'style.dart';

class TitleWithTextFormField extends StatelessWidget {
  const TitleWithTextFormField({super.key, required this.title, this.width, this.height, required this.controller, this.inputFormatters, this.sign, this.readOnly = false});
  final String title;
  final String? sign;
  final double? width;
  final double? height;
  final bool readOnly;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        wb5,
        SizedBox(
          height: width ?? 30,
          width: height ?? 200,
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
            inputFormatters: inputFormatters,
          ),
        ),
        Text(sign ?? ""),
      ],
    );
  }
}

class TitleWithTextFormFieldSpaceBetween extends StatelessWidget {
  const TitleWithTextFormFieldSpaceBetween({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.controller,
    this.inputFormatters,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.initialValue,
  });
  final String title;
  final bool readOnly;
  final double? width;
  final double? height;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        SizedBox(
          height: width ?? 30,
          width: height ?? 200,
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            cursorColor: black,
            initialValue: initialValue,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }
}
