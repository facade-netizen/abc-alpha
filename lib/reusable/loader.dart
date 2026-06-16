import 'package:flutter/material.dart';

import 'colors.dart';
import 'sized_box_hw.dart';

class LoaderWithScaffold extends StatelessWidget {
  const LoaderWithScaffold({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(child: LoaderContainerWithMessage(message: message)),
    );
  }
}

class LoaderContainerWithMessage extends StatelessWidget {
  final String? message;
  const LoaderContainerWithMessage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 150,
        child: Card(
          color: white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OverlappingLoader(),
              hb10,
              Text(
                message ?? "Loading...",
                style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlappingLoader extends StatefulWidget {
  const OverlappingLoader({super.key});

  @override
  State<OverlappingLoader> createState() => _OverlappingLoaderState();
}

class _OverlappingLoaderState extends State<OverlappingLoader> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    controller2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    Future.delayed(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      controller2.repeat(reverse: true);
    });
    animation1 = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
    animation2 = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: animation2,
            builder: (_, _) => Positioned(left: animation2.value, top: 5, child: _buildBall(Colors.blue)),
          ),
          AnimatedBuilder(
            animation: animation1,
            builder: (_, _) => Positioned(left: animation1.value, top: 5, child: _buildBall(Colors.yellow)),
          ),
        ],
      ),
    );
  }

  Widget _buildBall(Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
