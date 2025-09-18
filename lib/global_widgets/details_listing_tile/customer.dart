import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/call_log_helper.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/services/phone_masking.dart';
import '../../../global_widgets/custom_material_card/index.dart';
import '../../common/enums/page_type.dart';
import '../../core/constants/widget_keys.dart';
import '../../core/utils/job_financial_helper.dart';
import '../../core/utils/location_helper.dart';
import '../chip_with_avatar/index.dart';
import '../quick_book/index.dart';
import 'widgets/source_type_content.dart';
import 'widgets/label_value_tile.dart';

class CustomerListTile extends StatelessWidget {

  const CustomerListTile({
    super.key,
    required this.customer,
    required this.customerIndex,
    this.pageType,
    this.navigateToDetailScreen,
    this.openQuickActions,
    this.borderRadius,
    this.isLoadingMetaData = false,
    this.updateScreen,
    this.onTapEmailAction,
    this.onTapAppointmentChip,
  });

  final PageType? pageType;
  final CustomerModel customer;
  final void Function({int? customerID, int? index})? navigateToDetailScreen;
  final void Function({CustomerModel? customer, int? index})? openQuickActions;
  final int customerIndex;
  final double? borderRadius;
  final bool? isLoadingMetaData;
  final VoidCallback? updateScreen;
  final void Function()? onTapEmailAction;

  /// [onTapAppointmentChip] handles the click on appointment chip in the customer list tile
  final VoidCallback? onTapAppointmentChip;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      borderRadius: borderRadius ?? 18,
      child: InkWell(
        key: ValueKey('${WidgetKeys.customer}[$customerIndex]'),
        borderRadius: BorderRadius.circular(borderRadius ?? 18),
        onTap: () => navigateToDetailScreen!(customerID: customer.id!, index: customerIndex),
        onLongPress: () => openQuickActions!(customer: customer, index: customerIndex),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///   customer name
                        Visibility(
                        visible: customer.fullName?.isNotEmpty ?? false,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: JPText(
                                text: customer.fullName.toString(),
                                fontWeight: JPFontWeight.medium,
                                textAlign: TextAlign.start,
                                textSize: JPTextSize.heading4,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Visibility(
                            visible: (customer.companyName!.isNotEmpty || customer.contacts!.isNotEmpty) && customer.fullName!.isNotEmpty,
                            child: const SizedBox(height: 7)
                        ),
                        ///   organisation name
                        Visibility(
                          visible: customer.companyName!.isNotEmpty || (customer.isCommercial && customer.contacts!.isNotEmpty),
                          child: JPText(
                            text: customer.isCommercial && customer.contacts!.isNotEmpty ? customer.contacts![0].fullName.toString() : customer.companyName.toString(),
                            textAlign: TextAlign.start,
                            textSize: JPTextSize.heading4,
                            textColor: JPAppTheme.themeColors.tertiary,
                          ),
                        ),
                        (customer.fullName == null || ((customer.fullName) == "" ))
                            && (customer.companyName == null || ((customer.companyName) == "" ))
                            ? const SizedBox(height: 7,) : const SizedBox(height: 12,),

                        ///   phone number
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 5,
                          spacing: 5,
                          children: [
                            LabelValueTile(
                              visibility: customer.phones?.isNotEmpty ?? false,
                              label: "${"phone".tr}:",
                              value:Helper.isValueNullOrEmpty(customer.phones) ? '' : PhoneMasking.maskPhoneNumber(customer.phones?[0].number ?? ""),
                            ),
                            Visibility(
                              visible: pageType == PageType.customerListing && !ConsentHelper.isTransactionalConsent(),
                              child: ConsentStatus(
                                params: ConsentStatusParams(
                                  phoneConsentDetail: Helper.isValueNullOrEmpty(customer.phones) ? null : customer.phones?[0],
                                  email: customer.email,
                                  additionalEmails: customer.additionalEmails,
                                  customerId: customer.id,
                                  updateScreen: updateScreen,
                                  customer: customer
                                ),
                              ),
                            )
                          ],
                        ),
                        
                        Visibility(visible: customer.email?.isNotEmpty ?? false, child: const SizedBox(height: 7),),
                        ///   email
                        LabelValueTile(
                          visibility: customer.email?.isNotEmpty ?? false,
                          label: "${"email".tr}:",
                          value: customer.email.toString(),
                        ),
                        Visibility(visible: customer.addressString?.isNotEmpty ?? false, child: const SizedBox(height: 7),),
                        ///   address
                        LabelValueTile(
                          visibility: customer.addressString?.isNotEmpty ?? false,
                          label: "${"address".tr}:",
                          value: customer.addressString.toString(),
                        ),
                        Visibility(visible: customer.rep?.fullName.isNotEmpty ?? false, child: const SizedBox(height: 7),),
                        ///   sm/ cust. Rep
                        LabelValueTile(
                          visibility: customer.rep?.fullName.isNotEmpty ?? false,
                          label: "${"sm_cust_rep".tr}:",
                          value: (customer.rep?.fullName.toString() ?? ""),
                        ),

                        /// Consent Status
                        Visibility(
                          visible: pageType == PageType.customerListing && ConsentHelper.isTransactionalConsent(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: ConsentStatus(
                              params: ConsentStatusParams(
                                phoneConsentDetail: Helper.isValueNullOrEmpty(customer.phones) ? null : customer.phones?[0],
                                email: customer.email,
                                additionalEmails: customer.additionalEmails,
                                customerId: customer.id,
                                updateScreen: updateScreen,
                                isLoadingMeta: isLoadingMetaData ?? false,
                                customer: customer
                              ),
                            ),
                          ),
                        ),

                        /// Appointment Tile
                        if(!Helper.isValueNullOrEmpty(customer.appointmentDate))
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 5, 5),
                            child: JPChip(
                              text: customer.appointmentDate!,
                              textSize: JPTextSize.heading5,
                              avatarRadius: 10,
                              avatarBorderColor: JPAppTheme.themeColors.inverse,
                              backgroundColor: JPAppTheme.themeColors.inverse,
                              onTapChip: onTapAppointmentChip,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: JPAvatar(
                                  size: JPAvatarSize.small,
                                  backgroundColor: JPAppTheme.themeColors.primary,
                                  child: Icon(Icons.calendar_month, color: JPAppTheme.themeColors.base, size: 12,),
                                ),
                              ),
                            ),
                          ),
                        ///   Flags
                        Visibility(
                            visible: customer.flags?.isNotEmpty ?? false ,
                            child: const SizedBox(height: 5)
                        ),
                        Visibility(
                            visible: customer.flags?.isNotEmpty ?? false ,
                            child: JPChipWithAvatar(
                              jpChipType: JPChipType.flags,
                              flagList: customer.flags ?? [],)
                        ),
                      ]
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ///   job count
                      isLoadingMetaData ?? false
                        ? Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: SizedBox(
                          height: 26,
                          // width: 70,
                          child: JPLabel(
                            backgroundColor: JPAppTheme.themeColors.primary,
                            text: ' ',
                          ),
                        ),
                      )
                        : Visibility(
                          visible: customer.jobsCount != null && customer.jobsCount != 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: JPButton(
                              onLongPress: pageType == PageType.fileListing ? null : () {},
                              onPressed: pageType == PageType.fileListing || pageType == PageType.selectCustomer
                                ? null
                                : () => Get.toNamed(Routes.jobListing, arguments: {"customerID": customer.id}),
                              text: (customer.jobsCount ?? 0) <= 1 ? '${customer.jobsCount ?? 0} ${"job".tr.toUpperCase()}' : '${customer.jobsCount!} ${"jobs".tr.toUpperCase()}' ,
                              type: JPButtonType.solid,
                              colorType: JPButtonColorType.primary,
                              size: JPButtonSize.extraSmall,
                            ),
                          ),),

                      CustomerJobSourceTypeContent(sourceType: customer.sourceType,),

                      QuickBookIcon(
                        status: customer.quickbookSyncStatus,
                        origin: customer.origin,
                        isSyncDisable: customer.isDisableQboSync ? 1 : 0,
                        qbDesktopId: customer.qbDesktopId,
                        quickbookId: customer.quickbookId
                      ),
                    ]),
                ]),
              ///   Buttons
              Visibility(
                visible: (pageType != PageType.fileListing && pageType != PageType.selectCustomer),
                child: Row(
                  children: [
                    HasPermission(
                      reverse: true,
                      permissions: const[PermissionConstants.enableMasking],
                      child: Row(
                        children: [
                          Visibility(
                            visible: customer.phones?.isNotEmpty ?? false,
                            child: IconButton(
                              color: JPAppTheme.themeColors.primary,
                              iconSize: 20,
                              onPressed: () => SaveCallLogHelper.saveCallLogs(
                                CallLogCaptureModel(
                                  customerId: customer.id!,
                                  phoneLabel: customer.phones![0].label!,
                                  phoneNumber: customer.phones![0].number!)),
                              icon: const Icon(Icons.phone),
                            ),
                          ),
                          ///   map
                          IconButton(
                            color: JPAppTheme.themeColors.primary,
                            iconSize: 20,
                            onPressed:() => onTapEmailAction!(),
                            icon: const Icon(Icons.email),
                          ),
                          ///   map
                          Visibility(
                            visible: customer.addressString?.isNotEmpty ?? false,
                            child: IconButton(
                              color: JPAppTheme.themeColors.primary,
                              iconSize: 20,
                              onPressed:() => LocationHelper.openMapBottomSheet(
                                  query: customer.addressString.toString()
                              ),
                              icon: const Icon(Icons.location_on),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///   Distance
                    Visibility(
                      visible: customer.distance?.isNotEmpty ?? false,
                      child: JPText(
                        text:
                            "${JobFinancialHelper.getRoundOff((num.tryParse(customer.distance ?? "0") ?? 0), fractionDigits: 2)} mi",
                        textSize: JPTextSize.heading4,
                        textColor: JPAppTheme.themeColors.primary,
                      ),
                    ),
                  ],
                ),
            ),
           ]),
        ),
      ),
    );
  }

  Widget space() => const SizedBox(
    height: 5,
    width: 5,
  );
}