import 'package:flutter/material.dart';

import 'colors.dart';
import 'loader.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: white,
      extendBodyBehindAppBar: true,
      body: LoaderContainerWithMessage(message: message),
    );
  }
}
