import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Header/header.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'controller.dart';

class TiersSearchView extends StatelessWidget {
  const TiersSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TiersSearchController>(
      init: TiersSearchController(),
      global: false,
      builder: (controller) {
       return GestureDetector(
        onTap: Helper.hideKeyboard,
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            onBackPressed: Get.back<void>,
            titleWidget: JPInputBox(
              hintText: 'search_tier_name'.tr,
              controller: controller.searchTextController,
              type: JPInputBoxType.searchbarWithoutBorder,
              onChanged: controller.search,
              textSize: JPTextSize.heading4,
              scrollPadding: EdgeInsets.zero,
              fillColor: JPAppTheme.themeColors.base,
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 10
              ),
              debounceTime: 300,
              suffixChild: JPButton(
                text: 'add'.tr,
                size: JPButtonSize.size24,
                onPressed: () => controller.onTapItem(),
              ),
            ),
            backIconColor: JPAppTheme.themeColors.text,
            backgroundColor: JPAppTheme.themeColors.base,
            actions: const [
              SizedBox(width: 17)
            ],
          ),
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
            child: Container(
              color: JPAppTheme.themeColors.inverse,
              padding: const EdgeInsets.only(top: 1),
              child: ListView.separated(
                itemCount: controller.filterTiers.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return Material(
                    color: JPAppTheme.themeColors.base,
                    child: InkWell(
                      onTap: () => controller.onTapItem(index: index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16
                        ),
                        child: JPText(
                          text: controller.filterTiers[index],
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  );
                },
              )
            ),
          ),
        ),
      );
    });
  }
}
