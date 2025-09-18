import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../form_builder/index.dart';
import 'controller.dart';
import 'widget/index.dart';

class AddItemBottomSheetForm extends StatelessWidget {
  const AddItemBottomSheetForm({
    super.key,
    required this.pageType,
    this.sheetLineItemModel,
    this.isTaxable,
    this.onSave, 
    this.categoryId,
    this.srsBranchCode,
    this.shipToSequenceId,
    this.beaconAccount,
    this.beaconBranchCode,
    this.beaconJobNumber,
    this.forSupplierId,
    this.abcBranchCode,
    this.supplierAccountId
  });

  final AddLineItemFormType pageType;
  final SheetLineItemModel? sheetLineItemModel;
  final bool? isTaxable;
  final Function(SheetLineItemModel)? onSave;
  final String? categoryId;
  final String? srsBranchCode;
  final String? shipToSequenceId;
  final String? beaconBranchCode;
  final String? beaconJobNumber;
  final int? forSupplierId;
  final BeaconAccountModel? beaconAccount;
  final String? abcBranchCode;
  final String? supplierAccountId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddItemBottomSheetController>(
        init: AddItemBottomSheetController(
          pageType: pageType,
          sheetLineItemModel: sheetLineItemModel,
          categoryId: categoryId,
          srsBranchCode: srsBranchCode,
          shipToSequenceId: shipToSequenceId,
          isDefaultTaxable: isTaxable ?? true,
          beaconBranchCode: beaconBranchCode,
          beaconJobNumber: beaconJobNumber,
          forSupplierId: forSupplierId,
          beaconAccount: beaconAccount,
          abcBranchCode: abcBranchCode,
          supplierAccountId: supplierAccountId
        ),
        global: false,
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: JPFormBuilder(
            backgroundColor: JPAppTheme.themeColors.base,
            title: controller.getTitle,
            inBottomSheet: true,
            isCancelIconVisible: false,
            form : Form(
              key: controller.formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AddItemBottomSheetFormFields(controller: controller),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
            footer: Padding(
              padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: JPResponsiveDesign.popOverButtonFlex,
                      child: JPButton(
                        text: 'cancel'.toUpperCase(),
                        onPressed: () => Get.back(),
                        fontWeight: JPFontWeight.medium,
                        size: JPButtonSize.small,
                        colorType: JPButtonColorType.lightGray,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: JPResponsiveDesign.popOverButtonFlex,
                      child: JPButton(
                        onPressed:() => controller.addUpdateItem(onSave),
                        text: 'save'.tr.toUpperCase(),
                        fontWeight: JPFontWeight.medium,
                        size: JPButtonSize.small,
                        colorType: JPButtonColorType.primary,
                        textColor: JPAppTheme.themeColors.base,
                      ),
                    )
                  ]),
            ),
          ),
        )
    );
  }
}