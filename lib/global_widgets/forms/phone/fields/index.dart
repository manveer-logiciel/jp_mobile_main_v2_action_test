import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/forms/phone/controller.dart';
import 'tiles.dart';

class PhoneFormFields extends StatelessWidget {
  const PhoneFormFields({
    super.key,
    required this.controller,
    this.isDisabled = false,
    this.label,
    this.doShowPhoneBook = false,
    required this.isRequired,
    required this.showSufixIcon,
  });

  final PhoneFormController controller;
  final bool isDisabled;
  final String? label;
  final bool isRequired;
  final bool doShowPhoneBook;
  final bool showSufixIcon;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, index) {
          final data = controller.phoneFields[index];
          return PhoneFormTile(
             key: UniqueKey(),
             data: data,
             onTapPhoneType: () => controller.selectPhoneType.call(index),
             onDataChanged: () => controller.onValueChanged(index),
             canShowError: controller.canShowError,
             isDisabled: isDisabled,
             index: index,
             controller:controller,
             isRequired: isRequired,
             label: label,
             showSufixIcon: showSufixIcon,
             doShowPhoneBook: doShowPhoneBook,
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: controller.phoneFields.length,
    );
  }
}
