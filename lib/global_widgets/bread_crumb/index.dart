import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPBreadCrumb<T> extends StatefulWidget {
  const JPBreadCrumb({
    super.key,
    this.height = 30,
    required this.pathList,
    this.collapseAt = 3,
    this.onTapPath,
    required this.addToPopUp,
  });

  /// height can be used to give height to bar
  final double height;

  /// this list will contain the paths
  final List<T> pathList;

  /// collapseAt can be used to merge path into popUp
  /// and rest of the values will be displayed as it is, default value is [3]
  final int collapseAt;

  final Function(int index)? onTapPath;

  /// addToPopUp is a callback which is called when bread crumb size exceeds
  final VoidCallback addToPopUp;

  @override
  State<JPBreadCrumb<T>> createState() => _JPBreadCrumbState<T>();
}

class _JPBreadCrumbState<T> extends State<JPBreadCrumb<T>> {
  final key = GlobalKey();
  final crumbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    getBreadCrumbSize();

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          SizedBox(
            width: widget.pathList.length > widget.collapseAt ? 16 : 4,
          ),
          if (widget.pathList.length > widget.collapseAt)
            JPPopUpMenuButton<T>(
              itemList: widget.pathList
                  .sublist(0, widget.pathList.length - widget.collapseAt),
              offset: const Offset(0, 30),
              popUpMenuChild: (T val) {
                return JPText(
                  text: val.toString(),
                  textAlign: TextAlign.start,
                );
              },
              onTap: widget.onTapPath == null
                  ? null
                  : (T val) {
                      int index = widget.pathList
                          .indexWhere((element) => element == val);
                      widget.onTapPath!(index);
                    },
              childPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              popUpMenuButtonChild: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: JPColor.lightGray,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: 20,
                  child: SvgPicture.asset(
                    'assets/svg/more_horizontal.svg',
                    height: 4,
                    width: 10,
                  ),
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              key: crumbKey,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                key: key,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (widget.pathList.length < widget.collapseAt
                          ? widget.pathList
                          : widget.pathList.sublist(
                              widget.pathList.length - widget.collapseAt,
                              widget.pathList.length))
                      .map((e) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: widget.onTapPath == null
                              ? null
                              : () {
                                  int position = widget.pathList
                                      .indexWhere((element) => element == e);
                                  widget.onTapPath!(position);
                                },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: Get.width - 70,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: JPText(
                              text: e.toString(),
                              fontWeight: e == widget.pathList.last
                                  ? JPFontWeight.bold
                                  : JPFontWeight.regular,
                              textColor: JPAppTheme.themeColors.text,
                              textSize: JPTextSize.heading4,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (e != widget.pathList.last)
                          JPIcon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: JPAppTheme.themeColors.darkGray,
                          )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }

  RenderBox? getRenderObject() {
    if (key.currentContext == null) return null;
    return key.currentContext!.findRenderObject() as RenderBox?;
  }

  RenderBox? getCrumbObject() {
    if (crumbKey.currentContext == null) return null;
    return crumbKey.currentContext!.findRenderObject() as RenderBox?;
  }

  // This function will get crumb size and inform controller via callback if
  // lists need to be added in popup menu
  void getBreadCrumbSize() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    RenderBox? box = getRenderObject();
    RenderBox? crumbPaths = getCrumbObject();

    if (box == null) return;

    double crumbSize = box.size.width;
    double availableDeviceWidthForCrumb = (crumbPaths?.size.width ?? 0);

    if (crumbSize >= availableDeviceWidthForCrumb) {
      if (widget.collapseAt > 1) {
        widget.addToPopUp();
      }
    }
  }
}
