import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'section.dart';

class PlaceSrsOrderFormAllSections extends StatelessWidget {
  const PlaceSrsOrderFormAllSections({
    super.key,
    required this.controller,
  });

  final PlaceSupplierOrderFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (_, index) {
        final section = service.allSections[index];

        return PlaceSrsOrderFormSection(
          controller: controller,
          section: section,
          isFirstSection: index == 0,
        );
      },
      separatorBuilder: (_, index) => inputFieldSeparator,
      itemCount: service.allSections.length,
    );
  }

}
