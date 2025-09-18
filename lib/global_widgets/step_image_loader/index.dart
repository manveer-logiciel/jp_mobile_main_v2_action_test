import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';

class StepImageLoader extends StatelessWidget {

  final List<String>? imageList;
  final Uint8List? base64Images;

  const StepImageLoader({super.key, required this.imageList, this.base64Images});

  @override
  Widget build(BuildContext context) {
    return base64Images != null ? Image.memory(base64Images!) : showImage(imageList!.reversed.toList());
  }

  Widget showImage(List<String> url){
    return JPNetworkImage(
      src: url.first,
      height: double.maxFinite,
      width: double.maxFinite,
      placeHolder: url.isEmpty ? null : JPNetworkImage(
        src: url.last,
        height: double.maxFinite,
        width: double.maxFinite,
      ),
    );
  }

}
