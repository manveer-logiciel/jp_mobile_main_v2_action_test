import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'tile.dart';

class JPButtonSheet extends StatelessWidget {
  const JPButtonSheet({
    super.key,
    required this.onTapOption,
    required this.onTapOutSide,
    required this.options,
    this.isOpened = false,
    this.initialAlignment = Alignment.bottomCenter
  })  : isExpanded = options.length > 6,
        animationDuration = CommonConstants.transitionDuration;

  final VoidCallback? onTapOutSide;

  final Function(String) onTapOption;

  final List<JPQuickActionModel> options;

  final bool isOpened;

  final bool isExpanded;

  final Alignment initialAlignment;

  final int animationDuration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTapOutSide,
          child: Container(
            color: JPColor.transparent,
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: animationDuration),
          bottom: JPResponsiveDesign.floatingButtonSize - (isOpened ? 0 : 20),
          height: JPScreen.height,
          width: JPScreen.width,
          curve: Curves.easeInOut,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: (
                  Get.mediaQuery.padding.bottom / 2
              ) + (JPScreen.isMobile ? 10 : 25),
            ),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: animationDuration),
              opacity: isOpened ? 1 : 0.2,
              child: AnimatedAlign(
                duration: Duration(milliseconds: animationDuration),
                alignment: isOpened ? Alignment.bottomCenter : initialAlignment,
                child: AnimatedContainer(
                  height: isOpened ? null : 0,
                  width: isOpened ? null : 0,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: animationDuration),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                      maxWidth: isExpanded ? 350 : 250, maxHeight: 350),
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isExpanded ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.4),
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      return Opacity(
                        opacity: isOpened ? 1 : 0.4,
                        child: JPButtonSheetTile(
                          data: options[index],
                          onTap: () {
                            onTapOption.call(options[index].id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
