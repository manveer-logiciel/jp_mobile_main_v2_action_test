import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'sections/index.dart';
import 'shimmer.dart';

class PlaceSrsOrderForm extends StatelessWidget {
  const PlaceSrsOrderForm({super.key, required this.controller});

  final PlaceSupplierOrderFormController? controller;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => controller == null;

  PlaceSupplierOrderFormService get service => controller!.service;

  bool get isPlaceOrderInfoVisible =>
      service.type == MaterialSupplierType.beacon
          || service.type == MaterialSupplierType.abc
          || Helper.isSRSv2Id(service.fileListingModel?.worksheet?.materialList?.forSupplierId);

  @override
  Widget build(BuildContext context) {
    if (service.isLoading) {
      // returning shimmer if data is loading
      return const PlaceSrsOrderFormShimmer();
    }

    // returning actual widgets once loading done
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<PlaceSupplierOrderFormController>(
          init: controller ?? PlaceSupplierOrderFormController(),
          global: false,
          builder: (controller) {
            return JPWillPopScope(
              onWillPop: controller.onWillPop,
              child: Material(
                color: JPColor.transparent,
                child: JPFormBuilder(
                  title: controller.pageTitle,
                  onClose: controller.onWillPop,
                  form: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: isPlaceOrderInfoVisible,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 15),
                                child: JPText(
                                  text: "place_order_info".tr,
                                  textSize: JPTextSize.heading4,
                                  fontWeight: JPFontWeight.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: PlaceSrsOrderFormAllSections(
                            controller: controller,
                          ),
                        ),
                        SizedBox(
                          height: controller.formUiHelper.horizontalPadding,
                        ),
                      ],
                    ),
                  ),
                  footer: JPButton(
                    type: JPButtonType.solid,
                    text: controller.isSavingForm
                        ? ""
                        : controller.saveButtonText.toUpperCase(),
                    size: JPButtonSize.small,
                    disabled: controller.isSavingForm,
                    suffixIconWidget: showJPConfirmationLoader(
                      show: controller.isSavingForm,
                    ),
                    onPressed: controller.createPlaceSupplierOrder,
                  ),
                  inBottomSheet: isBottomSheet,
                ),
              ),
            );
          }),
    );
  }
}
