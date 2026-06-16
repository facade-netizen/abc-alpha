import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'sized_box_hw.dart';
import 'style.dart';

class CustomDropdownWithTitle extends StatefulWidget {
  const CustomDropdownWithTitle({super.key, required this.value, this.onChanged, required this.item, required this.title, this.height, this.width});
  final String title;
  final String value;
  final void Function(String?)? onChanged;
  final List<String> item;
  final double? height;
  final double? width;

  @override
  State<CustomDropdownWithTitle> createState() => _CustomDropdownWithTitleState();
}
 
class _CustomDropdownWithTitleState extends State<CustomDropdownWithTitle> {
  late ValueNotifier<String?> selectedValue;

  @override
  void initState() {
    super.initState();
    final String? safeValue = widget.item.contains(widget.value) ? widget.value : (widget.item.isNotEmpty ? widget.item[0] : null);
    selectedValue = ValueNotifier(safeValue);
  }

  @override
  void didUpdateWidget(CustomDropdownWithTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final String? safeValue = widget.item.contains(widget.value) ? widget.value : (widget.item.isNotEmpty ? widget.item[0] : null);
      selectedValue.value = safeValue;
    }
  }

  @override
  void dispose() {
    selectedValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        wb10,
        SizedBox(
          height: widget.height ?? 30,
          width: widget.width ?? 160,
          child: DropdownButtonFormField2<String>(
            valueListenable: selectedValue,
            isExpanded: true,
            iconStyleData: IconStyleData(icon: const Icon(Icons.arrow_drop_down, color: Colors.black)),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: grey),
              ),
            ),
            decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
            items: widget.item
                .map(
                  (status) => DropdownItem(
                    value: status,
                    child: Text(status.toUpperCase(), style: const TextStyle(fontSize: 14, color: black)),
                  ),
                )
                .toList(),
            onChanged: (newValue) {
              selectedValue.value = newValue;
              widget.onChanged?.call(newValue);
            },
          ),
        ),
      ],
    );
  }
}
