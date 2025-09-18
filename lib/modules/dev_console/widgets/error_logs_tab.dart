import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/dev_console/controller.dart';
import 'package:jobprogress/modules/dev_console/widgets/tile.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ErrorLogsTab extends StatelessWidget {
  final DevConsoleController controller;

  const ErrorLogsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.allLogs.isEmpty) {
      return NoDataFound(
        icon: Icons.code_off_outlined,
        title: 'no_logs_found'.tr,
      );
    }

    return Column(
      children: [
        JPListView(
          listCount: controller.allLogs.length,
          onLoadMore: controller.onLoadMore,
          onRefresh: controller.onRefresh,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (_, index) {
            if (index < controller.allLogs.length) {
              return DevConsoleTile(
                log: controller.allLogs[index],
              );
            } else if (controller.canShowMore) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadingCircle(
                    size: 25,
                    color: JPAppTheme.themeColors.primary,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
} 