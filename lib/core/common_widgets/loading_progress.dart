import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:barbqtonight/core/theme/colors.dart';

class LoadingProgress extends StatelessWidget {
  final double size;
  final Color color;
  const LoadingProgress({
    super.key,
    this.size = 80,
    this.color = Palette.themecolor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SpinKitChasingDots(
          color: color,
          duration: const Duration(milliseconds: 1000),
          size: size,
        ),
      ),
    );
  }
}
