import 'package:flutter/material.dart';

import 'colors.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;

  const CustomToggleSwitch({super.key, this.initialValue = false, this.onChanged, this.width = 70, this.height = 25});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggle() {
    setState(() {
      isOn = !isOn;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(isOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: isOn ? Colors.green : Colors.grey.shade400),
        child: Stack(
          children: [
            Center(
              child: Text(
                isOn ? "ON" : "OFF",
                style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.height - 10,
                height: widget.height - 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
