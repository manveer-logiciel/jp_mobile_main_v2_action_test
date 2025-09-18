import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/split_view/index.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'responsive_design/content.dart';
import 'responsive_design/list.dart';

class EmailsResponsiveView extends StatelessWidget {
  const EmailsResponsiveView({
    super.key,
    required this.controller,
    required this.header
  });

  final EmailListingController controller;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return JPResponsiveSplitView(
      header: header,
      list: EmailsListing(
        controller: controller,
      ),
      content:
       EmailListingContent(
        controller: controller,
      ),
      contentPlaceholder: NoDataFound(
        title: 'no_email_selected'.tr.capitalize,
        icon: Icons.email,
        descriptions: 'there_is_no_email_selected_in_inbox'.tr.capitalizeFirst,
      ),
      contentRouteName: Routes.emailDetailView,
    );
  }
}
