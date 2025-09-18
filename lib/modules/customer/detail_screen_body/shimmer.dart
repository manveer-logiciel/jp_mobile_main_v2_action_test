import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/custom_material_card/index.dart';
import '../../../global_widgets/safearea/safearea.dart';

class CustomerDetailScreenShimmer extends StatelessWidget {
  const CustomerDetailScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      top: false,
      containerDecoration: BoxDecoration(
          color: JPAppTheme.themeColors.inverse
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              ///   Name,
              CustomMaterialCard(
                child: Column(
                  children: [
                    ///   customer name, organisation name, job count
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///   customer name
                                  label(height: 15, width: 150),
                                  const SizedBox(height: 7,),
                                  ///   organisation name
                                  label(height: 10, width: 100),
                                ],
                              ),
                            ),
                          ),
                          ///   job count
                          JPLabel(
                            backgroundColor: JPAppTheme.themeColors.inverse,
                            text: ' ',
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: JPColor.darkGray,),
                    ///   Phone, Email, Map, Add job
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   phone
                          iconButton(iconData: Icons.call),
                          ///   email
                          iconButton(iconData: Icons.email_outlined),
                          ///   map
                          iconButton(iconData: Icons.location_on_outlined),
                          ///   add job
                          iconButton(iconData: Icons.add),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              /// Flags
              CustomMaterialCard(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   Label
                      label(height: 7, width: 50),
                      const SizedBox(height: 7,),
                      ///   Tags
                      Row(
                        children: [
                          label(height: 20, width: 80),
                          const SizedBox(width: 7,),
                          label(height: 20, width: 80),
                          const SizedBox(width: 7,),
                          label(height: 20, width: 80),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              /// Contact details
              CustomMaterialCard(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label(height: 8, width: 50),
                            const SizedBox(height: 9,),
                            label(height: 7, width: 100),
                          ],
                        ),
                        index < 1
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                JPButton(
                                  size: JPButtonSize.smallIcon,
                                  type: JPButtonType.outline,
                                  iconWidget: JPIcon(Icons.call, color: JPAppTheme.themeColors.inverse),
                                ),
                                const SizedBox(width: 5,),
                                JPButton(
                                  size: JPButtonSize.smallIcon,
                                  type: JPButtonType.outline,
                                  iconWidget: JPIcon(Icons.messenger_outline_outlined, color: JPAppTheme.themeColors.inverse),
                                )
                              ],
                            )
                          : index == 1
                            ? JPButton(
                                size: JPButtonSize.smallIcon,
                                type: JPButtonType.outline,
                                iconWidget: JPIcon(Icons.mail_outline, color: JPAppTheme.themeColors.inverse),
                              )
                            : index > 3
                            ? JPButton(
                                size: JPButtonSize.smallIcon,
                                type: JPButtonType.outline,
                                iconWidget: JPIcon(Icons.location_on_outlined, color: JPAppTheme.themeColors.inverse),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: JPColor.darkGray,),
                ),
              ),
              const SizedBox(height: 20,),
              /// Salesman details
              CustomMaterialCard(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(height: 8, width: 50),
                        const SizedBox(height: 9,),
                        index >= 1 && index < 3
                          ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            label(height: 28, width: 28),
                            const SizedBox(width: 5,),
                            label(height: 7, width: 100),
                          ],
                        )
                          : label(height: 7, width: 100),
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: JPColor.darkGray,),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconButton({IconData? iconData}) => Material(
  child: Material(
    color: JPColor.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          JPIcon(iconData!, color: JPAppTheme.themeColors.inverse,),
          const SizedBox(height: 5,),
          label(height: 7, width: 50),
        ],
      ),
    ),
  ),
);

Widget label ({double? height, double? width}) => Container(
  padding: EdgeInsets.zero,
  height: height,
  width: width,
  child:  const JPLabel(
    text: "",
    type: JPLabelType.lightGray,
  ),
);
