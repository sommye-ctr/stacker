import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacker/widgets/rounded_image_placeholder.dart';

class RoundedImage extends StatelessWidget {
  final String image;
  final double width;
  final double ratio;
  final double? radius;
  const RoundedImage({
    super.key,
    required this.image,
    required this.width,
    required this.ratio,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 8),
      child: CachedNetworkImage(
        imageUrl: image,
        width: width,
        fit: BoxFit.fill,
        height: width / ratio,
        placeholder: (context, url) {
          return RoundedImagePlaceholder(
            width: width,
            ratio: ratio,
            radius: radius,
          );
        },
        errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline_rounded),
      ),
    );
  }
}
