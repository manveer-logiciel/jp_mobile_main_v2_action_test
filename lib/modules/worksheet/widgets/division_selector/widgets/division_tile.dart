import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/details_listing_tile/widgets/label_value_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// A widget that represents a tile for selecting a division in the worksheet.
///
/// This widget displays the division details such as title, address, email, and phone.
/// It also includes a radio button to select the division.
class WorksheetDivisionSelectorTile extends StatelessWidget {
  const WorksheetDivisionSelectorTile({
    required this.label,
    required this.selectedDivisionId,
    required this.division,
    required this.defaultDivision,
    required this.onChanged,
    super.key
  });

  /// [label] - The label for the tile.
  final String label;

  /// [selectedDivisionId] - The ID of the currently selected division.
  final int? selectedDivisionId;

  /// [division] - The division model containing the division details.
  final DivisionModel? division;

  /// [onChanged] - The callback function to be called when the division is selected.
  final Function(dynamic) onChanged;

  /// [defaultDivision] - is used to display company address and other details,
  /// if missing from division
  final DivisionModel? defaultDivision;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: InkWell(
        onTap: () => onChanged(division?.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Radio button
              JPRadioBox(
                groupValue: selectedDivisionId,
                onChanged: onChanged,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                    value: division?.id,
                  )
                ],
              ),
              /// Division details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text: label,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    /// Title
                    LabelValueTile(
                      label: '${'name'.tr}:',
                      value: !Helper.isValueNullOrEmpty(division?.name)
                          ? division?.name
                          : "${defaultDivision?.name ?? ""} (${'default'.tr})",
                    ),
                    const SizedBox(height: 2,),
                    /// Address
                    LabelValueTile(
                      label: '${'address'.tr}:',
                      value: !Helper.isValueNullOrEmpty(division?.addressString)
                          ? division?.addressString
                          : "${defaultDivision?.addressString ?? ""} (${'default'.tr})",
                    ),
                    const SizedBox(height: 2,),
                    /// Email
                    LabelValueTile(
                      label: '${'email'.tr}:',
                      value: !Helper.isValueNullOrEmpty(division?.email)
                          ? division?.email
                          : "${defaultDivision?.email ?? ""} (${'default'.tr})",
                    ),
                    const SizedBox(height: 2,),
                    /// Phone Number
                    LabelValueTile(
                      label: '${'phone'.tr}:',
                      value: !Helper.isValueNullOrEmpty(division?.phone)
                          ? PhoneMasking.maskPhoneNumber(division!.phone!)
                          : "${PhoneMasking.maskPhoneNumber(defaultDivision?.phone ?? "")} (${'default'.tr})",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
