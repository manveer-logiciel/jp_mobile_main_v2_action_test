import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/core/constants/email_button_type.dart';
import 'package:jobprogress/core/utils/call_log_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/services/auth.dart';
import '../../../common/services/phone_masking.dart';
import '../../../global_widgets/chip_with_avatar/index.dart';
import '../../../global_widgets/custom_fields/index.dart';
import '../../../global_widgets/custom_material_card/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import 'detail_tile.dart';

class CustomerDetailScreenBody extends StatelessWidget {

  const CustomerDetailScreenBody({
    super.key,
    required this.customer,
    this.addFlagCallback,
    this.launchMapCallback,
    this.navigateToJobListingScreen,
    this.navigateToAddJobScreen, 
    this.updateScreen,});

  final CustomerModel customer;
  final void Function()? addFlagCallback;
  final void Function({bool isBillingAddress})? launchMapCallback;
  final void Function({int customerID})? navigateToJobListingScreen;
  final void Function()? navigateToAddJobScreen;
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      top: false,
      containerDecoration: BoxDecoration(
          color: JPAppTheme.themeColors.inverse
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              ///   Name,
              CustomMaterialCard(
                child: Column(
                  children: [
                    ///   customer name, organisation name, job count
                    Padding(
                      padding: EdgeInsets.fromLTRB(16,
                        20 + ((customer.fullName?.isNotEmpty ?? false) && !(customer.isCommercial)
                            ? (customer.companyName?.isNotEmpty ?? false) || (customer.isCommercial)
                              ? 0
                              : TextHelper.getTextSize(JPTextSize.heading4)/2
                            : TextHelper.getTextSize(JPTextSize.heading1)/2),
                        16,
                        20 + ((customer.fullName?.isNotEmpty ?? false) && !(customer.isCommercial)
                            ? (customer.companyName?.isNotEmpty ?? false) || (customer.isCommercial)
                              ? 0
                              : TextHelper.getTextSize(JPTextSize.heading4)/2
                            : TextHelper.getTextSize(JPTextSize.heading1)/2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///   customer name
                                  Visibility(
                                    visible: (customer.fullName?.isNotEmpty ?? false),
                                    child: JPText(
                                        text: customer.fullName.toString(),
                                        fontWeight: JPFontWeight.medium,
                                        textAlign: TextAlign.start,
                                        textSize: JPTextSize.heading1,),
                                  ),
                                  Visibility(
                                      visible: (customer.companyName!.isNotEmpty || customer.contacts!.isNotEmpty) && customer.fullName!.isNotEmpty,
                                      child: const SizedBox(height: 7,)),
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
                                ],
                              ),
                            ),
                          ),
                          ///   job count
                          Visibility(
                            visible: customer.jobsCount != null && customer.jobsCount != 0 ? true : false,
                            child: JPButton(
                              onPressed: navigateToJobListingScreen == null ? null : () => navigateToJobListingScreen!(customerID: customer.id!),
                              text: customer.jobsCount! <= 1 ? '${customer.jobsCount!} ${"job".tr.toUpperCase()}' : '${customer.jobsCount!} ${"jobs".tr.toUpperCase()}',
                              type: JPButtonType.solid,
                              colorType: JPButtonColorType.primary,
                              size: JPButtonSize.extraSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: JPColor.dimGray,),
                    ///   Phone, Email, Map, Add job
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   phone
                          iconButton(
                            iconData: Icons.phone,
                            buttonLabel: "phone".tr,
                            labelColor: customer.phones == null ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                            onTap: customer.phones == null ? null : () => SaveCallLogHelper.saveCallLogs(CallLogCaptureModel(customerId: customer.id!, phoneLabel: customer.phones![0].label!, phoneNumber: customer.phones![0].number! )),
                          ),
                          ///   email
                          JPEmailButton(
                            customerId: customer.id,
                            type: EmailButtonType.iconWithText
                          ),
                          ///   map
                          iconButton(
                            iconData: Icons.location_on,
                            buttonLabel: "map".tr,
                            labelColor: (customer.addressString?.isEmpty ?? true) ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                            onTap: (customer.addressString?.isEmpty ?? true) ? null : ()=> launchMapCallback!(isBillingAddress: false),
                          ),
                          ///   add job
                          iconButton(
                            iconData: Icons.add,
                            buttonLabel: "addJob".tr,
                            labelColor: AuthService.isPrimeSubUser() ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                            onTap: AuthService.isPrimeSubUser() ? null : navigateToAddJobScreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              /// Flags
              CustomMaterialCard(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   Label
                      JPText(
                        text: "flags".tr,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                      ///   Tags
                      JPChipWithAvatar(
                        jpChipType: JPChipType.flagsWithAddMoreButton,
                        flagList: customer.flags ?? [],
                        addCallback: addFlagCallback,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: (customer.phones?.isNotEmpty ?? false)
                      || (customer.email?.isNotEmpty ?? false)
                      || (customer.additionalEmails?.isNotEmpty ?? false)
                      || (customer.sourceType?.isNotEmpty ?? false)
                      || (customer.managementCompany?.isNotEmpty ?? false)
                      || (customer.propertyName?.isNotEmpty ?? false)
                      || (customer.addressString?.isNotEmpty ?? false)
                      || (customer.billingAddressString?.isNotEmpty ?? false),
                  child: const SizedBox(height: 20,)
              ),
              /// Contact details
              CustomMaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   Phone
                    for ( int index = 0; index < (customer.phones?.length ?? 0); index++ ) Column(
                      children: [
                        divider(
                        (index != (customer.phones?.length ?? 0))
                            || (customer.email?.isNotEmpty ?? false)
                            || (customer.managementCompany?.isNotEmpty ?? false)
                            || (customer.propertyName?.isNotEmpty ?? false)
                            || (customer.addressString?.isNotEmpty ?? false)
                            || (customer.billingAddressString?.isNotEmpty ?? false)
                        ),
                        CustomerDetailTile(
                          visibility: customer.phones?[index].number?.isNotEmpty ?? false,
                          customer: customer,
                          phoneModel: customer.phones?[index],
                          showConsentStatus: true,
                          updateScreen: updateScreen,
                          isDescriptionSelectable: customer.phones?[index].number?.isNotEmpty ?? false,
                          label: customer.phones?[index].label?.capitalize ?? "phone".tr.capitalize,
                          description: PhoneMasking.maskPhoneNumber(customer.phones![index].number ?? ""),
                          ext: customer.phones?[index].ext ?? "",
                          trailing: (customer.phones?[index].number?.isNotEmpty ?? false)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  JPSaveCallLog(callLogs: CallLogCaptureModel(customerId: customer.id!, phoneLabel: customer.phones![index].label!, phoneNumber: customer.phones![index].number! )),
                                  const SizedBox(width: 10,),
                                  JPSaveMessageLog(
                                    overrideConsentStatus: false,
                                    phone: customer.phones![index].number!,
                                    customerModel: customer,
                                    consentStatus: customer.phones![index].consentStatus,
                                    phoneModel: customer.phones![index],
                                  )
                                ],
                              ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    ///   Email
                    divider(customer.email?.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.email?.isNotEmpty ?? false,
                      label: "email".tr,
                      description: customer.email ?? "",
                      isDescriptionSelectable: customer.email?.isNotEmpty ?? false,
                      trailing: JPEmailButton(
                      customerId: customer.id,
                      )
                    ),
                    ///   Additional email
                    for ( int index = 0; index < (customer.additionalEmails?.length ?? 0); index++ ) Column(
                      children: [
                        divider(
                            (index != (customer.additionalEmails?.length ?? 0))
                                || (customer.phones?.isNotEmpty ?? false)
                                || (customer.email?.isNotEmpty ?? false)
                                || (customer.managementCompany?.isNotEmpty ?? false)
                                || (customer.propertyName?.isNotEmpty ?? false)
                                || (customer.addressString?.isNotEmpty ?? false)
                                || (customer.billingAddressString?.isNotEmpty ?? false)
                        ),
                        CustomerDetailTile(
                          visibility: customer.additionalEmails?[index]?.isNotEmpty ?? false,
                          label: "additional_email".tr,
                          description: customer.additionalEmails?[index] ?? "",
                          isDescriptionSelectable: customer.additionalEmails?[index]?.isNotEmpty ?? false,
                          trailing: JPEmailButton(
                            customerId: customer.id,
                          )
                        ),
                      ],
                    ),

                    ///   Customer Type
                    divider(true),
                    CustomerDetailTile(
                      visibility: true,
                      label: "customerType".tr,
                      description: customer.isCommercial ? "commercial".tr : "residential".tr,
                    ),
                    divider(customer.managementCompany?.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.managementCompany?.isNotEmpty ?? false,
                      label: "managementCompany".tr,
                      description: customer.managementCompany ?? "",
                    ),
                    divider(customer.propertyName?.isNotEmpty ?? false),
                    ///   Property Name
                    CustomerDetailTile(
                      visibility: customer.propertyName?.isNotEmpty ?? false,
                      label: "propertyName".tr,
                      description: customer.propertyName ?? "",
                    ),
                    divider(customer.addressString?.isNotEmpty ?? false,),
                    ///   Customer Address
                    CustomerDetailTile(
                      visibility: customer.addressString?.isNotEmpty ?? false,
                      label: "customerAddress".tr,
                      isDescriptionSelectable: customer.addressString?.isNotEmpty ?? false,
                      description: customer.addressString ?? "",
                      trailing: JPTextButton(
                        onPressed: ()=> (customer.addressString == null ) ? null : launchMapCallback!(isBillingAddress: false),
                        color: JPAppTheme.themeColors.primary,
                        icon: Icons.location_on,
                        iconSize: 24,
                      ),
                    ),
                    // Billing Name
                    divider(!Helper.isValueNullOrEmpty(customer.billingName)),
                    CustomerDetailTile(
                      visibility: !Helper.isValueNullOrEmpty(customer.billingName),
                      label: 'billing_name'.tr,
                      description: customer.billingName, 
                    ),
                    divider(customer.billingAddressString?.isNotEmpty ?? false),
                    ///   Billing Address
                    CustomerDetailTile(
                      visibility: customer.billingAddressString?.isNotEmpty ?? false,
                      label: "billingAddress".tr,
                      isDescriptionSelectable: customer.billingAddressString?.isNotEmpty ?? false,
                      description: customer.billingAddressString ?? "",
                      trailing: JPTextButton(
                        onPressed: ()=> (customer.billingAddressString == null ) ? null : launchMapCallback!(isBillingAddress: true),
                        color: JPAppTheme.themeColors.primary,
                        icon: Icons.location_on,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: (customer.rep?.fullName.isNotEmpty ?? false)
                      || (customer.referredBy?.fullName?.isNotEmpty ?? false)
                      || (customer.canvasser?.fullName.isNotEmpty ?? false)
                      || (customer.callCenterRep?.fullName.isNotEmpty ?? false)
                      || (customer.note?.isNotEmpty ?? false)
                      || (customer.createdAt!.isNotEmpty),
                  child: const SizedBox(height: 20,)
              ),
              /// Salesman details
              CustomMaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   Salesman
                    divider(customer.rep?.fullName.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: true,
                      label: "salesmanRep".tr,
                      imageURl: customer.rep?.profilePic ?? "",
                      color: customer.rep?.color,
                      description: customer.rep?.fullName ?? "unassigned".tr,
                      initial: customer.rep?.intial,
                    ),
                    ///   Salesman phone no
                    divider((customer.rep?.profile?.additionalPhone?.isNotEmpty ?? false) && (customer.rep?.profile?.additionalPhone?[0].number?.isNotEmpty ?? false)),
                    CustomerDetailTile(
                      visibility: (customer.rep?.profile?.additionalPhone?.isNotEmpty ?? false) && (customer.rep?.profile?.additionalPhone?[0].number?.isNotEmpty ?? false),
                      label: "salesmanRepPhone".tr,
                      description: PhoneMasking.maskPhoneNumber(customer.rep?.profile?.additionalPhone?.isNotEmpty ?? false ? (customer.rep?.profile?.additionalPhone?[0].number ?? "") : ""),
                      ext: customer.rep?.profile?.additionalPhone?.isNotEmpty ?? false ? (customer.rep?.profile?.additionalPhone?[0].ext ?? "") : "",
                      trailing: (customer.rep?.profile?.additionalPhone?.isNotEmpty ?? false ? (customer.rep?.profile?.additionalPhone?[0].number?.isNotEmpty ?? false) : false)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              JPSaveCallLog(callLogs: CallLogCaptureModel(customerId: customer.rep!.id, phoneLabel: customer.rep!.profile!.additionalPhone![0].label!, phoneNumber: customer.rep!.profile!.additionalPhone![0].number! )),
                              const SizedBox(width: 10,),
                              JPSaveMessageLog(
                                phone: customer.rep!.profile!.additionalPhone![0].number!,
                                customerModel: customer,
                                phoneModel: customer.rep!.profile!.additionalPhone![0],
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                    ),
                    ///   Referred By
                    if(!AuthService.isPrimeSubUser()) ...{
                    divider(!Helper.isValueNullOrEmpty(Helper.getCustomerReferredBy(customer))),
                      CustomerDetailTile(
                        visibility: !Helper.isValueNullOrEmpty(Helper.getCustomerReferredBy(customer)),  
                        label: "referredBY".tr,
                        description: Helper.getCustomerReferredBy(customer, showExistingCustomerLabel: true),
                      ),
                    },

                    ///   Canvasser
                    divider(customer.canvasser?.fullName.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.canvasser?.fullName.isNotEmpty ?? false,
                      label: "canvasser".tr,
                      color: customer.canvasser?.color,
                      imageURl: customer.canvasser?.profilePic ?? "",
                      description: customer.canvasser?.fullName ?? "",
                      initial: customer.canvasser?.intial,
                    ),
                    ///   Call Center Rep
                    divider(customer.callCenterRep?.fullName.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.callCenterRep?.fullName.isNotEmpty ?? false,
                      label: "callCenterRep".tr,
                      color: customer.callCenterRep?.color,
                      imageURl: customer.callCenterRep?.profilePic ?? "",
                      description: customer.callCenterRep?.fullName ?? "",
                      initial: customer.callCenterRep?.intial,
                    ),
                    ///   Note
                    divider(customer.note?.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.note?.isNotEmpty ?? false,
                      label: "note".tr,
                      description: customer.note ?? "",
                    ),

                    divider(customer.createdAt?.isNotEmpty ?? false),
                    CustomerDetailTile(
                      visibility: customer.createdAt?.isNotEmpty ?? false,
                      label: "created_at".tr,
                      description: DateTimeHelper.formatDate(customer.createdAt!, DateFormatConstants.dateTimeFormatWithoutSeconds),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: customer.customFields?.isNotEmpty ?? false,
                  child: const SizedBox(height: 20,)
              ),
              /// Custom Fields
              Visibility(
                visible: customer.customFields?.isNotEmpty ?? false,
                child: CustomMaterialCard(
                    child: CustomFields(customFields: customer.customFields ?? [],)
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

Widget divider(bool dividerVisibility) => Visibility(
    visible: dividerVisibility,
    child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray,)
);

Widget iconButton({IconData? iconData, String? buttonLabel, Color? labelColor, Function()? onTap}) => Expanded(
  child: Material(
    color: JPAppTheme.themeColors.base,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8,),
        child: Column(
          children: [
            JPIcon(iconData!, color: labelColor),
           const SizedBox(height: 3,),
            JPText(
              text: buttonLabel!,
              textAlign: TextAlign.start,
              textSize: JPTextSize.heading5,
              textColor: labelColor,
            ),
          ],
        ),
      ),
    ),
  ),
);
