import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/chip_with_avatar/index.dart';
import 'package:jobprogress/global_widgets/custom_fields/widgets/custom_field_tile.dart';
import 'package:jobprogress/global_widgets/link_text/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class CustomFields extends StatelessWidget {

  const CustomFields({
    super.key,
    required this.customFields});

  final List<CustomFieldsModel?> customFields;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: customFields.map((customField) {
        switch(customField!.type) {
          case "text" :
            return customFieldTextTile(
                customField: customField,
                dividerVisibility: (customFields.indexOf(customField)) < (customFields.length -1),
            );
          case "dropdown":
            return customFieldDropdownTile(
                dividerVisibility: (customFields.indexOf(customField)) < (customFields.length -1),
                customField: customField
            );
          case 'user':
            return customFieldUserTile(
                dividerVisibility: (customFields.indexOf(customField)) < (customFields.length -1),
                customField: customField
            );
          default :
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Widget divider(bool dividerVisibility) => Visibility(
      visible: dividerVisibility,
      child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray,)
  );


  Widget customFieldTextTile ({CustomFieldsModel? customField, bool? dividerVisibility}) => Column(
    children: [
      Visibility(
        visible: !Helper.isValueNullOrEmpty(customField?.value) && Helper.isTrue(customField?.isVisible),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomFieldTile(
            label: Visibility(
              visible: !Helper.isValueNullOrEmpty(customField?.name),
              child: JPText(
                text: customField?.name ?? "",
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.tertiary,
              ),
            ),
            description: JPLinkText(
              replaceTextWithUrl: false,
              text: customField?.value ?? "",
              textSize: JPTextSize.heading4, 
            ),
          ),
        ),
      ),
      divider(dividerVisibility ?? false),
    ],
  );

  Widget customFieldDropdownTile ({CustomFieldsModel? customField, bool? dividerVisibility}) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        ///   Group Name
        child: CustomFieldTile(
          group: JPText(
            text: (customField!.name ?? "").toUpperCase(),
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.secondaryText,
          ),
          label: Column(
            children: (customField.options ?? []).map((options) {
              return CustomFieldTile(
                /// Options
                label: JPText(
                  text: options?.name ?? "",
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary,
                ),
                description: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  ///   Sub-Options
                  child: JPLinkText(
                    replaceTextWithUrl: false,
                    text: options?.subOptions?.map((item) => item?.name).join(', ') ?? '',
                    textColor: JPAppTheme.themeColors.text,
                    textSize: JPTextSize.heading4,
                  ),
                ),
              );
            }).toList(),
          ) ,
        ),
      ),
      divider(dividerVisibility ?? false),
    ],
  );

  Widget customFieldUserTile ({CustomFieldsModel? customField, bool? dividerVisibility}) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        ///   Group Name
        child: CustomFieldTile(
          group: JPText(
            text: customField?.name ?? "",
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          label: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: JPChipWithAvatar(
                  jpChipType: JPChipType.userWithMoreButton,
                  userLimitedModelList: customField?.usersList,
                ),
              ),
            ]
          )
          ) ,
        ),
      divider(dividerVisibility ?? false),
    ],
  );
}
