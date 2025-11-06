import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/constants/image_utils.dart';

import '../api/api_config.dart';

class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? errorImage;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const CachedImageWidget({
    super.key,
    this.imageUrl,
    this.width,
    this.errorImage,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final String fullUrl = (imageUrl?.isNotEmpty ?? false)
        ? '${ApiConfig.imageBaseUrl}/$imageUrl'
        : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: fullUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            errorImage?? icBoy,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
