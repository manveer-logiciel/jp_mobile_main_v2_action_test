
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/group_by_listing/index.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/secondary_header.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/sort_by_listing/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummaryView extends StatelessWidget {

  const ClockSummaryView({super.key, this.tag});

  final String? tag;
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockSummaryController>(
      init: ClockSummaryController(),
      global: false,
      tag: tag,
      builder: (controller) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingApiRequest();
          return true;
        },
        child: JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: controller.getHeaderTitle(),
            onBackPressed: () {
              controller.cancelOnGoingApiRequest();
              Get.back();
            },
            actions: [
              JPTextButton(
                icon: Icons.menu,
                onPressed: () {
                  controller.scaffoldKey.currentState!.openEndDrawer();
                },
                color: JPAppTheme.themeColors.base,
                iconSize: 25,
              )
            ],
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: controller.isOpenedFromSecondaryDrawer ? "" : 'clock_summary',
            onRefreshTap: () {
              controller.refreshList(showLoading: true);
            },
          ),
          body: Column(
            children: [

              ClockSummarySecondaryHeader(
                controller: controller,
              ),

              Expanded(
                  child: controller.listingType == ClockSummaryListingType.groupBy
                      ? ClockSummaryGroupByListing(
                    controller: controller,
                  )
                      : ClockSummarySortByListing(
                    controller: controller,
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
