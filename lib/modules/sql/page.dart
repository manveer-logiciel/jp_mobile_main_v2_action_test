import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';

import 'package:jobprogress/modules/sql/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../common/enums/local_db_get_actions.dart';
import '../../common/enums/local_db_sync_actions.dart';
import '../../core/config/app_env.dart';
import 'widget/list_tile.dart';

class SqlView extends GetView<SqlController> {
  const SqlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SqlController>(
        builder: (context) {
          return JPScaffold(
              scaffoldKey: controller.scaffoldKey,
              appBar: JPHeader(
                onBackPressed: () {
                  Get.back();
                },
                title: "local_db_settings".tr,
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: JPButton(
                        onPressed: controller.isLoading.isEmpty
                            ? () => controller.syncAll() : null,
                        text: 'sync_all'.tr.toUpperCase(),
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                        textSize: JPTextSize.heading6,
                        textColor: JPAppTheme.themeColors.base,
                        colorType: JPButtonColorType.lightGray,
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                      child: (
                          Column(
                            children: [
                              ///   User
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: SQLListTile(
                                  title: 'user'.tr,
                                  description: controller.userUpdatedAt,
                                  onSyncTap: () => controller.syncUser(isLoading: SyncActions.syncUser),
                                  isLoading: controller.isLoading.contains(SyncActions.syncUser),
                                ),
                              ),
                              divider(),
                              ///   Division
                              SQLListTile(
                                title: 'division'.tr,
                                description: controller.divisionUpdatedAt,
                                onSyncTap: () => controller.syncDivision(isLoading: SyncActions.syncDivision),
                                isLoading: controller.isLoading.contains(SyncActions.syncDivision),
                              ),
                              divider(),
                              ///   Tag
                              SQLListTile(
                                title: 'tag'.tr,
                                description: controller.tagUpdatedAt,
                                onSyncTap: () => controller.syncTag(isLoading: SyncActions.syncTag),
                                isLoading: controller.isLoading.contains(SyncActions.syncTag),
                              ),
                              divider(),
                              ///   Referral source
                              SQLListTile(
                                title: 'referral_source'.tr,
                                description: controller.referralUpdatedAt,
                                onSyncTap: () => controller.syncReferralSource(isLoading: SyncActions.syncReferralSource),
                                isLoading: controller.isLoading.contains(SyncActions.syncReferralSource),
                              ),
                              divider(),
                              ///   Trade type & Work type
                              SQLListTile(
                                title: 'work_type'.tr,
                                description: controller.tradeUpdatedAt,
                                onSyncTap: () => controller.syncTradeType(isLoading: SyncActions.syncTradeType),
                                isLoading: controller.isLoading.contains(SyncActions.syncTradeType),
                              ),
                              divider(),
                              ///   Company
                              SQLListTile(
                                title: 'company'.tr,
                                description: controller.companyUpdatedAt,
                                onSyncTap: () => controller.syncCompany(isLoading: SyncActions.syncCompany),
                                isLoading: controller.isLoading.contains(SyncActions.syncCompany),
                              ),
                              divider(),
                              ///   Country
                              SQLListTile(
                                title: 'country'.tr,
                                description: controller.countryUpdatedAt,
                                onSyncTap: () => controller.syncCountry(isLoading: SyncActions.syncCountry),
                                isLoading: controller.isLoading.contains(SyncActions.syncCountry),
                              ),
                              divider(),
                              ///   State
                              SQLListTile(
                                title: 'state'.tr,
                                description: controller.stateUpdatedAt,
                                onSyncTap: () => controller.syncState(isLoading: SyncActions.syncState),
                                isLoading: controller.isLoading.contains(SyncActions.syncState),
                              ),
                              divider(),
                              ///   Flags
                              SQLListTile(
                                title: 'flags'.tr,
                                description: controller.flagUpdatedAt,
                                onSyncTap: () => controller.syncFlags(isLoading: SyncActions.syncFlags),
                                isLoading: controller.isLoading.contains(SyncActions.syncFlags),
                              ),
                              divider(),
                              ///   Workflow Stages
                              SQLListTile(
                                title: 'workflow_stages'.tr,
                                description: controller.workflowStagesUpdatedAt,
                                onSyncTap: () => controller.syncWorkflowStages(isLoading: SyncActions.syncWorkflowStages),
                                isLoading: controller.isLoading.contains(SyncActions.syncWorkflowStages),
                              ),
                              divider(),
                              if (AppEnv.currentEnv != Environment.prod)...{
                                ///   Get users with tags & Divisions
                                SQLListTile(
                                  title: 'get_users_with_tags_division'.tr,
                                  onSyncTap: () => controller.getUsersWithTagsDivision(
                                      isLoading: LocalDBOtherActions.getUsersWithTagsDivision),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getUsersWithTagsDivision),
                                ),
                                divider(),

                                ///   Get divisions with users
                                SQLListTile(
                                  title: 'get_divisions_with_users'.tr,
                                  onSyncTap: () => controller.getDivisionsWithUsers(
                                      isLoading: LocalDBOtherActions.getDivisionsWithUsers),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getDivisionsWithUsers),
                                ),
                                divider(),

                                ///   Get Tags With Users
                                SQLListTile(
                                  title: 'get_tags_with_users'.tr,
                                  onSyncTap: () => controller.getTagsWithUsers(
                                      isLoading: LocalDBOtherActions.getTagsWithUsers),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getTagsWithUsers),
                                ),
                                divider(),

                                ///   Get Referrals
                                SQLListTile(
                                  title: 'get_referrals'.tr,
                                  onSyncTap: () => controller.getReferrals(
                                      isLoading: LocalDBOtherActions.getReferrals),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getReferrals),
                                ),
                                divider(),

                                ///   Get all trades
                                SQLListTile(
                                  title: 'get_all_trades'.tr,
                                  onSyncTap: () => controller.getTrades(
                                      isLoading: LocalDBOtherActions.getTrades),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getTrades),
                                ),
                                divider(),

                                ///   Get Companies
                                SQLListTile(
                                  title: 'get_companies'.tr,
                                  onSyncTap: () => controller.getCompanies(
                                      isLoading: LocalDBOtherActions.getCompanies),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getCompanies),
                                ),
                                divider(),

                                ///   Get Countries
                                SQLListTile(
                                  title: 'get_countries'.tr,
                                  onSyncTap: () => controller.getCountries(
                                      isLoading: LocalDBOtherActions.getCountries),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getCountries),
                                ),
                                divider(),

                                ///   Get States
                                SQLListTile(
                                  title: 'get_states'.tr,
                                  onSyncTap: () => controller.getStates(
                                      isLoading: LocalDBOtherActions.getStates),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getStates),
                                ),
                                divider(),

                                ///   Get Flags
                                SQLListTile(
                                  title: 'get_flags'.tr,
                                  onSyncTap: () =>
                                      controller.getFlags(isLoading: LocalDBOtherActions.getFlags),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getFlags),
                                ),
                                divider(),

                                ///   Get Workflow Stages
                                SQLListTile(
                                  title: 'get_workflow_stages'.tr,
                                  onSyncTap: () => controller.getWorkflowStages(
                                      isLoading: LocalDBOtherActions.getWorkflowStages),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.getWorkflowStages),
                                ),
                                divider(),

                                ///   Get 1 user record
                                SQLListTile(
                                  title: 'get_1_user_record'.tr,
                                  onSyncTap: () => controller.get1UserRecord(
                                      isLoading: LocalDBOtherActions.get1UserRecord),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.get1UserRecord),
                                ),
                                divider(),

                                ///   Delete DB
                                SQLListTile(
                                  title: 'delete_db'.tr,
                                  onSyncTap: () =>
                                      controller.deleteDB(isLoading: LocalDBOtherActions.deleteDB),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.deleteDB),
                                ),
                                divider(),

                                ///   Migrate DB
                                SQLListTile(
                                  title: 'migrate_old_db'.tr,
                                  onSyncTap: () =>
                                      controller.migrateOldDB(isLoading: LocalDBOtherActions.migrateOldDB),
                                  isLoading: controller.isLoading.contains(LocalDBOtherActions.migrateOldDB),
                                ),
                                divider(),
                              },
                              const SizedBox(height: 5,),
                            ],
                          ))
                  )
              )
          );
        });
  }

  Widget divider() => Divider(color: JPAppTheme.themeColors.dimGray, height: 1,);
}