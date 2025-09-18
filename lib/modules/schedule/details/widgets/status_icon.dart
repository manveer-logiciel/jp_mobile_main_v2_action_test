import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/utils/helpers.dart';

class ScheduleDetailStatusIcon extends StatelessWidget {
  const ScheduleDetailStatusIcon({
    required this.status,
    super.key
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    dynamic setting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.showScheduleConfirmationStatus);

    if(!Helper.isTrue(setting)) {
      return const SizedBox.shrink();
    }

    if (status == 'accept' || status == 'confirm') {
      return JPIcon(
        Icons.check_circle,
        color: JPAppTheme.themeColors.success,
        size: 14,
      );
    }
    else if (status == 'decline') {
      return JPIcon(
        Icons.cancel,
        color: JPAppTheme.themeColors.secondary,
        size: 14,
      );
    } else {
      return JPIcon(
        Icons.pending,
        color: JPAppTheme.themeColors.warning,
        size: 14,
      );
    }
  }
}
