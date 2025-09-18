import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/share_via_jobprogress/controller.dart';
import 'package:jobprogress/global_widgets/share_via_jobprogress/warning_tile.dart';
import 'package:jobprogress/global_widgets/twilio_status_banner/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ShareViaJobProgress extends StatelessWidget {
  const ShareViaJobProgress({
    required this.controller, 
    super.key, 
  });

  final SendViaJobProgressController controller;

  bool get isTextDisabled => !controller.haveConsent || !controller.isTwilioTextingEnabled;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: Helper.hideKeyboard,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
            color: JPAppTheme.themeColors.base,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 10
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getHeader(),
              Flexible(
                child: getSheet(controller, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Column(
      children: [
        JPResponsiveBuilder(
          mobile: Container(
            height: 3,
            width: 30,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            color: JPAppTheme.themeColors.inverse,
          ),
          tablet: const SizedBox(
            height: 10,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, bottom: 5),
                child: JPText(
                    text: 'send_text'.tr.toUpperCase(),
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading3)),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: JPTextButton(
                isDisabled: controller.isLoading,
                onPressed: Get.back<void>,
                color: JPAppTheme.themeColors.text,
                icon: Icons.clear,
                iconSize: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getSheet(
      SendViaJobProgressController controller, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.isTwilioTextingEnabled && !ConsentHelper.isTransactionalConsent()) ...{
                          Visibility(
                            visible: controller.showWarningMessage &&
                                !controller.haveConsent,
                            child: WarningTile(
                              onTap: controller.openConsentForm,
                              text: controller.warningText ?? '',
                              buttonText: controller.warningButtonText,
                              suffixText: controller.warningSuffixText,
                            ),
                          ),
                        } else if (!controller.isTwilioTextingEnabled) ...{
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: JPTwilioStatusBanner(
                                status: controller.twilioTextStatus,
                              ),
                            )
                          },
                        JPInputBox(
                          isRequired: true,
                          controller: controller.phoneController,
                          label: 'phone'.tr,
                          maxLength: 14,
                          disabled: !controller.isTwilioTextingEnabled,
                          suffixChild: (controller.jobId != null ||
                                  controller.customerModel != null)
                              ? InkWell(
                                  onTap: controller.getContactsLists,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.person,
                                      color: JPAppTheme.themeColors.primary,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PhoneMasking.inputFieldMask()
                          ],
                          fillColor: JPAppTheme.themeColors.base,
                          onChanged:controller.validateConsent,
                          type: JPInputBoxType.withLabel,
                          onSaved: (value) {
                            controller.phone = value;
                          },
                          validator: (val) => controller.validatePhone(val),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (controller.doShowConsentStatus) ...{
                          ConsentStatus(
                            params: ConsentStatusParams(
                              phoneConsentDetail: controller.phoneConsent?.toPhoneModel(),
                              job: controller.jobModel,
                              customer: controller.getSelectedContactByType<CustomerModel>(),
                              contact: controller.getSelectedContactByType<CompanyContactListingModel>(),
                              onConsentChanged: controller.updateConsentStatus,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        },
                        const SizedBox(
                          height: 5,
                        ),
                        JPInputBox(
                          isRequired: true,
                          disabled: isTextDisabled,
                          controller: controller.messageController,
                          label: 'text'.tr,
                          type: JPInputBoxType.withLabel,
                          maxLength: !isTextDisabled ? 1500: null,
                          fillColor: JPAppTheme.themeColors.base,
                          maxLines: 5,
                          isCounterText: true,
                          onSaved: (value) {
                            controller.message = value;
                          },
                          validator:(val){
                            return controller.validateMessage(val);
                          }
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                JPAttachmentDetail(
                  titleText: 'attachment'.tr,
                  titleTextColor: JPAppTheme.themeColors.darkGray,
                  attachments: controller.attachments,
                  isAttachmentCount: false,
                  isEdit: true,
                  disabled: controller.isLoading || isTextDisabled,
                  addCallback: controller.showFileAttachmentSheet,
                  onTapCancelIcon: controller.removeAttachment,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        JPButton(
          onPressed: () => controller.onValidate(),
          size: JPButtonSize.medium,
          text: controller.isLoading ? '' : 'send'.tr.toUpperCase(),
          iconWidget: showJPConfirmationLoader(show: controller.isLoading),
          disabled: controller.isLoading || isTextDisabled,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
