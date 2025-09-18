import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_option_fields.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/modules/appointment_details/widgets/results/place_holder.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'result_tile.dart';

class AppointmentResult extends StatelessWidget {

  const AppointmentResult({
    super.key,
    this.results,
    this.onTapBtn,
    this.resultOption
  });

  final VoidCallback? onTapBtn;

  final AppointmentResultOptionsModel? resultOption;

  final List<AppointmentResultOptionFieldModel>? results;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          /// title and icon
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: JPText(
                    text: '${'appointment_result'.tr.toUpperCase()}${resultOption?.name != null ? '(${resultOption?.name?.capitalize})' : ''}',
                    textColor: JPAppTheme.themeColors.darkGray,
                    textAlign: TextAlign.start,
                    fontWeight: JPFontWeight.medium,
                  ),
                ),

                /// add edit icon
                JPButton(
                  onPressed: onTapBtn,
                  colorType: JPButtonColorType.lightBlue,
                  size: JPButtonSize.smallIcon,
                  iconWidget: Icon(
                    results == null || results!.isEmpty
                        ? Icons.add
                        : Icons.edit_outlined,
                    size: 15,
                    color: JPAppTheme.themeColors.primary,
                  ),
                )
              ],
            ),
          ),
          results == null || results!.isEmpty
              ? AppointmentResultPlaceholder(
                  onTapBtn: onTapBtn,
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return AppointmentResultTile(
                      title: results![index].name ?? '',
                      subTitle: results![index].value ?? '',
                    );
                  },
                  separatorBuilder: (_, index) {
                    return Divider(
                      thickness: 1,
                      height: 1,
                      color: JPAppTheme.themeColors.dimGray,
                    );
                  },
                  itemCount: results!.length,
                )
        ],
      ),
    );
  }
}
