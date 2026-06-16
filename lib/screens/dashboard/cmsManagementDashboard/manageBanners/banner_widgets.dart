import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../reusable/colors.dart';

class BannerLT extends StatelessWidget {
  const BannerLT({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(color: black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CustomTFCard extends StatelessWidget {
  const CustomTFCard({
    super.key,
    required this.title,
    this.width,
    this.controller,
    this.inputFormatters,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.maxLines,
    this.readOnly = false,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
  });
  final String title;
  final bool readOnly;
  final double? width;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? hintText;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerLT(title: title),
        SizedBox(
          width: width ?? 300,
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            cursorColor: black,
            initialValue: initialValue,
            maxLines: maxLines,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: white,
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: TextStyle(color: grey, fontSize: 14),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: grey, width: 0.5),
              ),
            ),
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }
}

class BannerDropdown extends StatelessWidget {
  const BannerDropdown({super.key, required this.title, required this.items, this.value, this.onChanged, this.hint});
  final String title;
  final String? value, hint;
  final List<String> items;
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerLT(title: title),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: grey, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value == '' ? null : value,
            items: items.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            hint: Text(hint ?? 'Select', style: TextStyle(color: grey)),
            dropdownColor: white,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            style: const TextStyle(color: black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class CmsCTAButton extends StatelessWidget {
  const CmsCTAButton({super.key, required this.title, this.icon, this.action, this.color, this.type = 0});
  final String title;
  final IconData? icon;
  final Color? color;
  final void Function()? action;
  final int type;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: action,
      icon: Icon(icon, size: type == 1 ? 20 : 16),
      label: Text(
        title,
        style: TextStyle(fontSize: type == 1 ? 15 : 12, fontWeight: type == 1 ? FontWeight.bold : FontWeight.normal),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? blue,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 6),
      ),
    );
  }
}

class CustomGridViewCard extends StatelessWidget {
  const CustomGridViewCard({super.key, this.height, required this.children, this.count, this.spacing});
  final int? count;
  final double? height, spacing;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 10) / (count ?? 2);
        final double itemHeight = height ?? 75;
        final double aspectRatio = itemWidth / itemHeight;
        return GridView.count(
          crossAxisCount: (count ?? 2),
          crossAxisSpacing: spacing ?? 10,
          mainAxisSpacing: spacing ?? 10,
          shrinkWrap: true,
          childAspectRatio: aspectRatio,
          children: children,
        );
      },
    );
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
