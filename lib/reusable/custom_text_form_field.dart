import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'style.dart';

class LabelForTF extends StatelessWidget {
  const LabelForTF({super.key, required this.title, this.topPadding});
  final String title;
  final double? topPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 20, bottom: 10.0),
      child: Text(title, style: const TextStyle(color: black)),
    );
  }
}

class ReadOnlyText extends StatelessWidget {
  const ReadOnlyText({super.key, this.onTap, this.width, this.trailing, this.decoration, this.initialValue, required this.title, this.customWidth = true});
  final String title;
  final double? width;
  final Widget? trailing;
  final bool? customWidth;
  final String? initialValue;
  final Decoration? decoration;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelForTF(title: title),
        Container(
          width: width ?? (customWidth == true ? 300 : size.width),
          height: 50,
          decoration:
              decoration ??
              BoxDecoration(
                color: secondaryColor,
                border: Border.all(color: grey),
                borderRadius: BorderRadius.circular(8),
              ),
          child: ListTile(
            onTap: onTap,
            title: Text((initialValue == null || initialValue!.isEmpty) ? "-" : "$initialValue", overflow: TextOverflow.ellipsis),
            trailing: trailing,
          ),
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.width,
    this.onTap,
    this.onSaved,
    this.onChanged,
    this.maxLines,
    this.hintText,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.title,
    this.inputFormatters,
    this.readOnly = false,
    this.customWidth = true,
    this.enabled = true,
    this.lTFPadding,
    this.onFieldSubmitted,
  });
  final String title;
  final int? maxLines;
  final bool? enabled;
  final double? width;
  final double? lTFPadding;
  final bool? readOnly;
  final String? hintText;
  final bool? customWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelForTF(title: title, topPadding: lTFPadding),
        SizedBox(
          width: width ?? (customWidth == true ? 300 : size.width),
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            onChanged: onChanged,
            onTap: onTap,
            enabled: enabled,
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            initialValue: initialValue,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            decoration: tfInputDecoration.copyWith(
              errorStyle: const TextStyle(color: red, overflow: TextOverflow.ellipsis),
              prefixIcon: prefixIcon,
              hintText: hintText,
              suffixIcon: suffixIcon,
            ),
            inputFormatters: inputFormatters,
            validator:
                validator ??
                (value) {
                  if (readOnly == true) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return "Field is required.";
                  } else {
                    return null;
                  }
                },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}
class CustomTextFormFieldWithOutValidator extends StatelessWidget {
  const CustomTextFormFieldWithOutValidator({
    super.key,
    this.width,
    this.onTap,
    this.onSaved,
    this.onChanged,
    this.maxLines,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.title,
    this.inputFormatters,
    this.readOnly = false,
    this.customWidth = true,
    this.enabled = true,
    this.lTFPadding,
    this.onFieldSubmitted,
  });
  final String title;
  final int? maxLines;
  final bool? enabled;
  final double? width;
  final double? lTFPadding;
  final bool? readOnly;
  final String? hintText;
  final bool? customWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelForTF(title: title, topPadding: lTFPadding),
        SizedBox(
          width: width ?? (customWidth == true ? 300 : size.width),
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            onChanged: onChanged,
            onTap: onTap,
            enabled: enabled,
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            initialValue: initialValue,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            decoration: tfInputDecoration.copyWith(
              errorStyle: const TextStyle(color: red, overflow: TextOverflow.ellipsis),
              prefixIcon: prefixIcon,
              hintText: hintText,
              suffixIcon: suffixIcon,
            ),
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}

BoxDecoration decoration = BoxDecoration(
  color: lbo2,
  border: Border.all(color: blue),
  borderRadius: BorderRadius.circular(8),
);

class PriceContainer extends StatelessWidget {
  const PriceContainer({super.key, required this.title, this.width, this.height, this.color});
  final String title;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 45,
      width: width ?? 145,
      alignment: Alignment.center,
      decoration: decoration,
      child: Text(
        title,
        style: TextStyle(color: color ?? black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PasswordCustomTextFormField extends StatelessWidget {
  const PasswordCustomTextFormField({
    super.key,
    this.width,
    this.onTap,
    this.onSaved,
    this.maxLines,
    this.hintText,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.title,
    this.inputFormatters,
    this.readOnly = false,
    this.customWidth = true,
    this.enabled = true,
    this.lTFPadding,
    this.obscureText = false,
    this.obscuringCharacter,
  });
  final String title;
  final int? maxLines;
  final bool? enabled;
  final double? width;
  final double? lTFPadding;
  final bool? readOnly;
  final String? hintText;
  final bool obscureText;
  final bool? customWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final void Function()? onTap;
  final String? obscuringCharacter;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelForTF(title: title, topPadding: lTFPadding),
        SizedBox(
          width: width ?? (customWidth == true ? 300 : size.width),
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            onChanged: onSaved,
            onTap: onTap,
            enabled: enabled,
            obscureText: obscureText,
            obscuringCharacter: obscuringCharacter ?? '',
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            initialValue: initialValue,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            decoration: tfInputDecoration.copyWith(
              errorStyle: const TextStyle(color: red, overflow: TextOverflow.ellipsis),
              prefixIcon: prefixIcon,
              hintText: hintText,
              suffixIcon: suffixIcon,
            ),
            inputFormatters: inputFormatters,
            validator:
                validator ??
                (value) {
                  if (readOnly == true) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return "Field is required.";
                  } else {
                    return null;
                  }
                },
          ),
        ),
      ],
    );
  }
}
