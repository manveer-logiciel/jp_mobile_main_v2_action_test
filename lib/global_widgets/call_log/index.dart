import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/core/utils/call_log_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPSaveCallLog extends StatelessWidget {
  final CallLogCaptureModel callLogs;
  const JPSaveCallLog({super.key, required this.callLogs});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPColor.transparent,
      child: JPTextButton(
        onPressed: () => SaveCallLogHelper.saveCallLogs(callLogs),
        color: JPAppTheme.themeColors.primary,
        icon: Icons.local_phone,
        iconSize: 24,
      ),
    );
  }
}