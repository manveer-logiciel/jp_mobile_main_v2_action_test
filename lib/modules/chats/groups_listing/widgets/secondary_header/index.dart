import 'package:flutter/material.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'responsive_design/desktop.dart';
import 'responsive_design/mobile.dart';

class GroupsListingSecondaryHeader extends StatelessWidget {
  const GroupsListingSecondaryHeader({super.key, required this.controller});

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return JPResponsiveBuilder(
      mobile: GroupsListingSecondaryHeaderMobile(
        controller: controller,
      ),
      desktop: GroupsListingSecondaryHeaderDesktop(
        controller: controller,
      ),
    );
  }

}
