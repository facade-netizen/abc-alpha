import 'package:flutter/material.dart';

import '../../../../../../reusable/colors.dart';

class FancyMarketRunnerBox extends StatefulWidget {
  final String value;
  final bool isBack;

  const FancyMarketRunnerBox({super.key, required this.value, required this.isBack});

  @override
  State<FancyMarketRunnerBox> createState() => _FancyMarketRunnerBoxState();
}

class _FancyMarketRunnerBoxState extends State<FancyMarketRunnerBox> {
  late Color bgColor;

  @override
  void initState() {
    super.initState();
    bgColor = widget.isBack ? backBtn : layBtn;
    _flashYellow();
  }

  void _flashYellow() {
    setState(() {
      bgColor = primaryColor.withValues(alpha: 0.5);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() {
        bgColor = widget.isBack ? backBtn : layBtn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(color: bgColor),
      child: Container(
        height: 40,
        decoration: BoxDecoration(border: Border.all(color: grey, width: 0.5)),
        child: Center(
          child: SelectableText(
            widget.value,
            style: const TextStyle(fontSize: 12, color: black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class FancyBetListHeader extends StatelessWidget {
  const FancyBetListHeader({super.key, this.onTap, required this.title});
  final Function()? onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [SelectableText(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))],
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final String text;
  final Color bg;
  final Color color;
  final bool bold;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  const CustomTableCell({
    super.key,
    required this.text,
    this.bg = Colors.white,
    this.color = Colors.black,
    this.bold = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(color: bg),
      child: SelectableText(
        text,
        style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color),
      ),
    );
  }
}
