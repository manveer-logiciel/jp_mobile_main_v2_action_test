import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jp_mobile_flutter_ui/Avatar/size.dart';

// Using this widget to show network(any server image) images
// This widget is sending cloud front cookie header to show JobProgress server images
class JPNetworkImage extends StatelessWidget {
  const JPNetworkImage({
    super.key,
    this.src,
    this.size,
    this.boxFit = BoxFit.contain,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.borderRadius = 0,
    this.placeHolder,
  });

  final String? src;
  final JPAvatarSize? size;
  final BoxFit? boxFit;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget? placeHolder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius!),
      child: (src?.isNotEmpty ?? false) ? CachedNetworkImage(
        imageUrl: src!,
        height: height,
        width: width,
        fit: boxFit,
        httpHeaders: CookiesService.savedCookies,
        placeholder: (context, error){
          return getPlaceholder();
        },
        errorWidget: (context, error, stackTrace){
          return getPlaceholder();
        },
      ) : getPlaceholder(),
    );
  }

  Widget getPlaceholder() => placeHolder ?? Image.asset('assets/images/alt-image.png');

}
