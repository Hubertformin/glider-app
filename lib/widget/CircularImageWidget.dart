import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/image_provider/_image_provider_io.dart';

class CircularImageWidget extends StatelessWidget {
  final double size;
  final String imageUrl;

  CircularImageWidget(this.size, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: OptimizedCacheImageProvider(imageUrl),
                fit: BoxFit.fill)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
  }
}
