import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/company_contacts/detail/phone_details.dart';
import 'package:jobprogress/modules/company_contacts/list_tile/company_contact_notes_shimmer.dart';
import 'package:jobprogress/modules/company_contacts/list_tile/contcts_view_shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'header.dart';
import 'notes.dart';
import 'other_details.dart';

class CompanyContactListingViews extends GetView<CompanyContactViewController> {
  const CompanyContactListingViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JPScaffold(
        backgroundColor: JPAppTheme.themeColors.inverse,
        scaffoldKey: controller.scaffoldKey,
        endDrawer: JPMainDrawer(selectedRoute: 'company_contacts_view', onRefreshTap: controller.refreshPage),
        body: GetBuilder<CompanyContactViewController>(
          builder: (_) => JPSafeArea(
            child: controller.isLoading
                ? const ContactViewShimmer()
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: CompanyContactsHeader()),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: Delegate(),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          color: JPAppTheme.themeColors.inverse,
                          child: Column(
                            children: [
                              CompanyContactsPhoneDetails(),
                              const SizedBox(
                                height: 20,
                              ),
                              CompanyContactsOtherDetails(),
                              controller.isNoteLoading ? 
                                const NotesShimmer() : 
                                CompanyContactsNotes(),
                              const SizedBox(height: 45)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        floatingActionButton: JPButton(
              size: JPButtonSize.floatingButton,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.navigateToUpdateCompanyContact,
            ),);
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: JPAppTheme.themeColors.inverse,
      );

  @override
  double get maxExtent => 20;

  @override
  double get minExtent => 20;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
