import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RoundedImagePlaceholder extends StatelessWidget {
  final double width, ratio;
  final double? radius;

  const RoundedImagePlaceholder({
    super.key,
    required this.width,
    required this.ratio,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: (width / ratio),
          color: Colors.grey,
        ),
      ),
    );
  }
}
