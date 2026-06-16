import 'package:flutter/material.dart';

import 'colors.dart';
import 'sized_box_hw.dart';

class CustomLoginButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomLoginButton({super.key, required this.onPressed});

  @override
  State<CustomLoginButton> createState() => _CustomLoginButtonState();
}

class _CustomLoginButtonState extends State<CustomLoginButton> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), lowerBound: 0.0, upperBound: 0.05);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_hoverController);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _hoverController.forward();
        setState(() => isHovered = true);
      },
      onExit: (_) {
        _hoverController.reverse();
        setState(() => isHovered = false);
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: isHovered
                  ? LinearGradient(colors: [Color.fromARGB(255, 95, 196, 255), Color.fromARGB(255, 113, 115, 255)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : LinearGradient(colors: [Color.fromARGB(255, 95, 196, 255), Color.fromARGB(255, 113, 115, 255)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isHovered ? 0.25 : 0.15),
                  blurRadius: isHovered ? 12 : 6,
                  offset: Offset(0, isHovered ? 6 : 3),
                ),
              ],
              border: Border.all(color: Colors.black12, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomHoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? textColor;
  final String title;
  final bool isDisabled;
  final FontWeight? fontWeight;
  const CustomHoverButton({
    super.key,
    required this.onPressed,
    this.height,
    this.width,
    this.fontSize,
    this.textColor,
    required this.title,
    this.isDisabled = false,
    this.fontWeight,
  });

  @override
  State<CustomHoverButton> createState() => _CustomHoverButtonState();
}

class _CustomHoverButtonState extends State<CustomHoverButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: widget.height ?? 30,
          width: widget.width ?? 100,
          decoration: BoxDecoration(
            gradient: widget.isDisabled
                ? disabledGradient
                : isHovered
                ? lightBlueGradient
                : manuGradient,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: widget.isDisabled ? grey : blue, width: 1),
          ),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(color: widget.isDisabled ? grey : widget.textColor ?? white, fontSize: widget.fontSize ?? 14, fontWeight: widget.fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlineTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? textColor;
  final Color? boxColor;
  final FontWeight? fontWeight;

  const CustomOutlineTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
    this.borderColor = Colors.black,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.all(0),
    this.textColor,
    this.fontSize,
    this.boxColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 0.6),
          borderRadius: BorderRadius.circular(borderRadius),
          color: boxColor ?? Colors.grey[300],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: textColor ?? grey, fontSize: fontSize, fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }
}

class ColoredTextButton extends StatefulWidget {
  const ColoredTextButton({super.key, required this.name, this.width, this.height, this.onTap, this.fontSize, this.textColor});

  final String name;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? textColor;
  final void Function()? onTap;

  @override
  State<ColoredTextButton> createState() => _ColoredTextButtonState();
}

class _ColoredTextButtonState extends State<ColoredTextButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: widget.height ?? 30,
          width: widget.width ?? 30,
          decoration: BoxDecoration(
            gradient: isHovered ? loginBtnGradient : loginBtnGradientOp,
            border: Border.all(color: black, width: 0.6),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(color: widget.textColor ?? Colors.yellow, fontSize: widget.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class DWButtons extends StatelessWidget {
  const DWButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleButton(label: 'D', onPressed: () {}),
          Container(width: 1, height: double.infinity, color: Colors.grey.shade500),
          SingleButton(label: 'W', onPressed: () {}),
        ],
      ),
    );
  }
}

class SingleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  final Color selectedColor;
  final BorderRadiusGeometry? borderRadius;
  const SingleButton({super.key, required this.label, required this.onPressed, this.isSelected = false, this.selectedColor = Colors.transparent, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: isSelected ? selectedColor : Colors.white, borderRadius: borderRadius),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: black),
        ),
      ),
    );
  }
}

class CustomOCTAButton extends StatelessWidget {
  const CustomOCTAButton({super.key, required this.title, this.width, this.height, this.action, this.fontSize, this.textColor, this.borderColor, this.fontWeight, this.icon});
  final IconData? icon;
  final String title;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 120,
      height: height ?? 30,
      child: OutlinedButton(
        onPressed: action,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(white),
          foregroundColor: WidgetStateProperty.all(textColor ?? blue),
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            return BorderSide(color: borderColor ?? grey, width: states.contains(WidgetState.hovered) ? 1.2 : 1);
          }),
          overlayColor: WidgetStateProperty.all(blue.withValues(alpha: 0.1)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: textColor ?? black),
            if (icon != null) wb4,
            Text(
              title,
              style: TextStyle(fontSize: fontSize ?? 14, fontWeight: fontWeight ?? FontWeight.w500, color: textColor ?? black),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomECTAButton extends StatelessWidget {
  const CustomECTAButton({super.key, required this.title, this.width, this.height, this.action, this.fontSize, this.textColor, this.borderColor, this.fontWeight});

  final String title;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 130,
      height: height ?? 30,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(blue.withValues(alpha: 0.7)),
          foregroundColor: WidgetStateProperty.all(textColor ?? white),
          side: WidgetStateProperty.all(BorderSide(color: borderColor ?? blue, width: 1)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          overlayColor: WidgetStateProperty.all(white.withValues(alpha:0.1)),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 6)),
          elevation: WidgetStateProperty.all(1),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize ?? 14, fontWeight: fontWeight ?? FontWeight.w600, color: textColor ?? white),
        ),
      ),
    );
  }
}
