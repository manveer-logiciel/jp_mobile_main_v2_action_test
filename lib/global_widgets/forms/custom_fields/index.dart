import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/fields/dropdown.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/fields/text.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/fields/users.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class CustomFieldsForm extends StatefulWidget {
  const CustomFieldsForm({
    super.key,
    required this.fields,
    this.onDataChange,
    this.userlist,
    this.isDisabled = false,
  });

  /// [fields] contains the list of fields to be displayed
  final List<CustomFormFieldsModel> fields;

  /// [isDisabled] helps in disabling fields
  final bool isDisabled;

  /// [onDataChange] used to listen changes on the go
  final Function(String)? onDataChange;

  /// [userlist] contains the list of users
  final List<JPMultiSelectModel>? userlist;

  @override
  State<CustomFieldsForm> createState() => CustomFieldsFormState();
}

class CustomFieldsFormState extends State<CustomFieldsForm> {
  late CustomFieldFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomFieldFormController>(
      init: CustomFieldFormController(widget.fields),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      global: false,
      builder: (controller) {
        return JPExpansionTile(
            enableHeaderClick: true,
            preserveWidgetOnCollapsed: true,
            initialCollapsed: controller.isSectionExpanded,
            borderRadius: controller.uiHelper.sectionBorderRadius,
            isExpanded: controller.isSectionExpanded,
            headerPadding: EdgeInsets.symmetric(
              horizontal: controller.uiHelper.horizontalPadding,
              vertical: controller.uiHelper.verticalPadding,
            ),
            header: JPText(
              text: 'custom_fields'.tr.toUpperCase(),
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.darkGray,
              textAlign: TextAlign.start,
            ),
            trailing: (_) => JPIcon(Icons.expand_more,color: JPAppTheme.themeColors.secondaryText,),
            contentPadding: EdgeInsets.only(
              left: controller.uiHelper.horizontalPadding,
              right: controller.uiHelper.horizontalPadding,
              bottom: controller.uiHelper.verticalPadding,
            ),
            onExpansionChanged: (val) => controller.onSectionExpansionChanged(val),
            children: [
              Form(
                key: controller.formKey,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    final field = widget.fields[index];
                    ///   Text Fields
                    if (field.isTextField) {
                      return CustomFieldTextInput(
                        key: Key('${WidgetKeys.customFieldText}_${field.id}'),
                        field: field,
                        onDataChange: controller.onValueChanged,
                        isDisabled: widget.isDisabled,
                      );
                    }
                    // User Fields
                    if(field.isUserField) {
                      return CustomFieldUserDropdown(
                        key: Key('${WidgetKeys.customFieldDropdown}_${field.id}'),
                        field: field,
                        onDataChange: controller.onValueChanged,
                        isDisabled: widget.isDisabled, 
                        controller: controller, 
                        userlist: widget.userlist ?? [],
                      );
                    }
                    ///   Dropdown Field
                    return CustomFieldDropdown(
                      field: field,
                      controller: controller,
                      onDataChange: controller.onValueChanged,
                      isDisabled: widget.isDisabled,
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(
                      height: controller.uiHelper.verticalPadding,
                    );
                  },
                  itemCount: widget.fields.length,
                ),
              )
            ]);
      },
    );
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidate: scrollOnValidate);
  }
}
