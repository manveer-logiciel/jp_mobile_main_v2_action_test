import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AutomationListingHeader extends StatelessWidget {
  final AutomationListingController controller; 

  const AutomationListingHeader({
    super.key, 
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(top: 26, bottom: 16, left: 16, right: 16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JPText(
              text: 'automation_alerts'.tr.toUpperCase(),
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading3,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !AuthService.isStandardUser(),
                  child:  JPFilterIcon(
                    isFilterActive: true,
                    onTap: () => controller.openFilterDialog(),
                  ),
                ),
                FromFirebase(
                  child: (val) {
                    if(CountService.automationCount > 0) {
                      return JPTextButton(
                        key: const Key(WidgetKeys.automationCountButton),
                        onPressed: controller.refreshList,
                        text: '${CountService.automationCount} ${'new'.tr.capitalizeFirst!}',
                        fontWeight: JPFontWeight.bold,
                        textSize: JPTextSize.heading4,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  realTimeKeys: const [RealTimeKeyType.automationFeedUpdated], 
                )
              ],
            ),
          ],
        ),
      );
    }
  }
