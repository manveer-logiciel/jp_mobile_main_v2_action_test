
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomerFlagsSection extends StatelessWidget {

  const CustomerFlagsSection({
    super.key,
    required this.controller
  });

  final CustomerFormController controller;

  CustomerFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {

    if(service.selectedFlags.isEmpty) {
      return const SizedBox();
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ///   Flags
                JPText(
                  text: "flags".tr.capitalize!,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.text,
                ),

              ///   Flag Chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 5,
                  spacing: 5,
                  children: service.selectedFlags.map((flag) {
                    return JPChip(
                      text: flag.label,
                      textSize: JPTextSize.heading5,
                      avatarRadius: 10,
                      avatarBorderColor: JPAppTheme.themeColors.inverse,
                      backgroundColor: JPAppTheme.themeColors.inverse,
                      child: flag.child,
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                height: controller.formUiHelper.horizontalPadding,
              ),

            ],
          ),
        ),
      ],
    );

  }
}
