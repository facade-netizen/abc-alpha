import 'package:flutter/material.dart';

import 'colors.dart';

class CustomLoginContainer extends StatelessWidget {
  const CustomLoginContainer({super.key, required this.width, required this.height, this.child, required this.borderRadius});
  final double width;
  final double height;
  final double borderRadius;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: applyOpacity(black, 0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: grey, width: 0.5),
        boxShadow: [BoxShadow(color: applyOpacity(black, 0.2), blurRadius: 8)],
      ),
      child: child,
    );
  }
}
