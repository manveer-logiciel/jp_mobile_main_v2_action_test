
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/global_value_listener/index.dart';
import 'package:jobprogress/modules/uploads/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FloatingUploadIndicator extends StatelessWidget {
  const FloatingUploadIndicator({
    super.key,
    this.onTap,
    this.size = 70,
  });

  final VoidCallback? onTap;

  final double size;

  @override
  Widget build(BuildContext context) {
    return GlobalValueListener<UploadsListingController>(
      child: (controller) {
        if(controller.isAllItemsPaused) {
          return const SizedBox();
        } else {
          return Card(
            shape: const CircleBorder(),
            color: JPAppTheme.themeColors.base,
            elevation: 3,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                height: size,
                width: size,
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: JPAppTheme.themeColors.lightBlue,
                            border: Border.all(
                              color: JPAppTheme.themeColors.dimGray,
                              width: 2
                            )
                          ),
                          margin: const EdgeInsets.all(2),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: SizedBox(
                            height: size - 2,
                            width: size - 2,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(JPAppTheme.themeColors.primary),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),

                      Positioned.fill(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              JPText(
                                text: controller.getProgressCount(),
                                textColor: JPAppTheme.themeColors.primary,
                                fontFamily: JPFontFamily.montserrat,
                                textSize: JPTextSize.heading5,
                                fontWeight: JPFontWeight.medium,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              JPText(
                                text: 'uploading'.tr,
                                textColor: JPAppTheme.themeColors.primary,
                                fontFamily: JPFontFamily.montserrat,
                                dynamicFontSize: 10,
                                fontWeight: JPFontWeight.medium,
                              ),
                            ],
                          ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
