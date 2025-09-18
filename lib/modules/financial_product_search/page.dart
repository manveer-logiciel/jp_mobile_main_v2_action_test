import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/financial_product_search/widget/financial_product_search_tile.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Header/header.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../core/utils/helpers.dart';
import '../../global_widgets/safearea/safearea.dart';
import '../../global_widgets/scaffold/index.dart';
import 'controller.dart';

class FinancialProductSearchView extends StatelessWidget {
  const FinancialProductSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinancialProductController>(
      init: FinancialProductController(),
      global: false,
      builder: (controller) {
       return GestureDetector(
        onTap: Helper.hideKeyboard,
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            onBackPressed: Get.back<void>,
            titleWidget: JPInputBox(
              key: const ValueKey(WidgetKeys.productSearchInput),
              hintText: controller.getHintText(),
              controller: controller.searchTextController,
              type: JPInputBoxType.searchbarWithoutBorder,
              onChanged: controller.debouncingSearch,
              textSize: JPTextSize.heading4,
              scrollPadding: EdgeInsets.zero,
              fillColor: JPAppTheme.themeColors.base,
              padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10
              ),
              debounceTime: 500,
              suffixChild: Visibility(
                visible: controller.isAddButtonVisible,
                child: JPButton(
                  text: 'add'.tr,
                  size: JPButtonSize.size24,
                  onPressed: () => controller.onTapItem(),
                ),
              ),
            ),
            backIconColor: JPAppTheme.themeColors.text,
            backgroundColor: JPAppTheme.themeColors.base,
            actions: const [
               SizedBox(width: 17,)
            ],
          ),
          scaffoldKey: controller.scaffoldKey,
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
            child: Container(
              color: JPAppTheme.themeColors.inverse,
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  FinancialProductSearchTile(controller: controller),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
