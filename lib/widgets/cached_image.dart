import 'package:cached_network_image/cached_network_image.dart';
import 'package:caco_cooking/common/colors.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends CachedNetworkImage {

  CustomCachedNetworkImage({Key? key,
    required String imageUrl,
    required double height_,
    required double dim30,
    imageBuilder
  }) : super(
      key: key,
      imageUrl: imageUrl,
      fadeInDuration: const Duration(microseconds: 300),
      fadeOutDuration: const Duration(microseconds: 0),
      width: double.infinity,
      fit: BoxFit.cover,
      cacheKey: imageUrl,
      errorWidget: (context, url, error) => const Icon(Icons.error),
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return SizedBox(
          width: dim30,
          height: dim30,
          child: const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor)
              )),
        );
      },
      imageBuilder: imageBuilder
  );

}
