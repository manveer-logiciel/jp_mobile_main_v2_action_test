
// Using this widget to show local images

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPFileImage extends StatelessWidget {
  const JPFileImage({
    super.key,
    required this.path,
    this.size,
    this.boxFit = BoxFit.contain,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.borderRadius = 0,
    this.placeHolder,
  });

  final String path;
  final JPAvatarSize? size;
  final BoxFit? boxFit;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget? placeHolder;

  @override
  Widget build(BuildContext context) {
    if (Helper.isValueNullOrEmpty(path)) {
      return getPlaceHolder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius!),
      child: Image.file(
        File(path),
        height: height,
        width: width,
        fit: boxFit,
        errorBuilder: (_, __, ___) {
          return getPlaceHolder();
        },
      ),
    );
  }

  Widget getPlaceHolder() {
    return placeHolder ?? Image.asset('assets/images/alt-image.png', height: height, width: width,);
  }

}