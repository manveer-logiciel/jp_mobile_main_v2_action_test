import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/tax_tile.dart';

class WorksheetCalculationsTaxSection extends StatelessWidget {
  const WorksheetCalculationsTaxSection({
    required this.controller,
    super.key,
  });

  final WorksheetFormController controller;

  WorksheetFormService get service => controller.service;

  WorksheetSettingModel? get settings => controller.service.settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Line item tax
        WorksheetCalculationsTaxTile(
          title: 'tax'.tr,
          amount: service.calculatedAmounts.lineItemTax,
          isVisible: settings!.addLineItemTax,
          hidePercentage: true,
        ),

        /// Tax all
        WorksheetCalculationsTaxTile(
          title: 'tax_all'.tr,
          amount: service.calculatedAmounts.taxAll,
          percent: settings?.getTaxAllRate,
          isVisible: settings?.applyTaxAll,
          revisedTaxRate: settings?.revisedTaxAll,
          isRevisedTaxApplied: settings?.isRevisedTaxApplied,
          onTapEdit: service.selectTaxRateAll,
          onTapRevisedTax: service.toggleRevisedTax,
        ),

        /// Tax Material
        WorksheetCalculationsTaxTile(
          title: 'tax_material'.tr,
          amount: service.calculatedAmounts.materialTax,
          percent: settings?.getMaterialTaxRate,
          isVisible: settings!.applyTaxMaterial! && settings!.hasMaterialItem,
          revisedTaxRate: settings?.revisedMaterialTax,
          isRevisedTaxApplied: settings?.isRevisedMaterialTaxApplied,
          onTapRevisedTax: service.toggleRevisedMaterialTax,
          onTapEdit: service.selectMaterialTaxRate,
        ),

        /// Tax labor
        WorksheetCalculationsTaxTile(
          title: 'tax_labor'.tr,
          amount: service.calculatedAmounts.laborTax,
          percent: settings?.getLaborTaxRate,
          isVisible: settings!.applyTaxLabor! && settings!.hasLaborItem,
          revisedTaxRate: settings?.revisedLaborTax,
          isRevisedTaxApplied: settings?.isRevisedLaborTaxApplied,
          onTapRevisedTax: service.toggleRevisedLaborTax,
          onTapEdit: service.selectLaborTaxRate,
        ),
      ],
    );
  }
}
