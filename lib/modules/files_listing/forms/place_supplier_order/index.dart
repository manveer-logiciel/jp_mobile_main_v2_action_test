import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PlaceSupplierOrderFormView extends StatelessWidget {
  const PlaceSupplierOrderFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<PlaceSupplierOrderFormController>(
        init: PlaceSupplierOrderFormController(),
        global: false,
        dispose: (state) {},
        builder: (controller) {
          return AbsorbPointer(
            absorbing: controller.isSavingForm,
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: JPHeader(
                title: controller.pageTitle,
                backgroundColor: JPColor.transparent,
                titleColor: JPAppTheme.themeColors.text,
                backIconColor: JPAppTheme.themeColors.text,
                titleTextOverflow: TextOverflow.ellipsis,
                onBackPressed: controller.onWillPop,
                actions: !controller.service.isLoading ? [
                  const SizedBox(
                    width: 16,
                  ),
                  Center(
                    child: JPButton(
                      key: const ValueKey(WidgetKeys.placeOrder),
                      disabled: controller.isSavingForm,
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      text: controller.isSavingForm ? "" : controller.saveButtonText,
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                        size: 10,
                      ),
                      onPressed: controller.createPlaceSupplierOrder,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ] : [],
              ),
              body: PlaceSrsOrderForm(
                controller: controller,
              ),
            ),
          );
        },
      ),
    );
  }
}
