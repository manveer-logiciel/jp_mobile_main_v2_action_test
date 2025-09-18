import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailListingSecondaryHeader extends StatelessWidget {
  const EmailListingSecondaryHeader({
    super.key,
    required this.controller,
  });

  final EmailListingController controller;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(right: 16, left: 10, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: JPTextButton(
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openDrawer();
                    },
                    color: JPAppTheme.themeColors.tertiary,
                    icon: Icons.menu,
                    iconSize: 24,
                  ),
                ),
                Expanded(
                  child: JPInputBox(
                    type: JPInputBoxType.searchbar,
                    controller: controller.textController,
                    fillColor: JPScreen.isDesktop ? JPAppTheme.themeColors.base : null,
                    onChanged: controller.onSearchTextChanged,
                    debounceTime: 700,
                  hintText: 'search_by_to_from_subject'.tr
                  ),
                )
              ],
            ),

          ]
        ),
      );
  }
}