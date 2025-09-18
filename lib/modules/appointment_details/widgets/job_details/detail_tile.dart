
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentJobDetailTile extends StatelessWidget {

  const AppointmentJobDetailTile({
    super.key,
    required this.data, 
    this.jobId, 
    this.customer, 
    this.updateScreen,
  });

  final dynamic data;
  final int? jobId;
  final CustomerModel? customer;
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {
    return dataTypeToTile();
  }

  Widget dataTypeToTile() {
    if(data is PhoneModel) {
      final phone = (data as PhoneModel);
      return phoneTile(
        showConsentStatus: phone.showConsentStatus,
        phone: phone
      );
    }
    else if(data is List<String>) {
      List<String> emailList = data;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            JPText(
              text: 'additional_recipients'.tr,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
            for(int i =0; i< emailList.length; i++)
             emailTile(title: emailList[i])
          ],
        ),
      );
    }
    else {
      return const SizedBox();
    }
  }

  Widget tileWrapper({required String title, required Widget subTitle, List<Widget>? icons}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, icons == null ? 16 : 11, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                JPText(
                  text: title,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary,
                ),
                const SizedBox(
                  height: 6,
                ),
                subTitle
              ],
            ),
          ),
          Row(
            children: icons ?? [],
          ),
        ],
      ),
    );
  }

  Widget phoneTile({
    PhoneModel? phone,
    bool showConsentStatus = false
  }) {
    return tileWrapper(
        title: phone?.label ?? 'phone'.tr.capitalize!,
        subTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                JPText(
                  text: PhoneMasking.maskPhoneNumber(phone?.number??''),
                ),

                if(!Helper.isValueNullOrEmpty(phone?.ext))...{
                  const SizedBox(
                    width: 10,
                  ),
                  JPText(
                    text: 'ext'.tr.capitalizeFirst!,
                    textColor: JPAppTheme.themeColors.tertiary,
                  ),
                  JPText(
                    text: ' ${phone?.ext}',
                  ),
                },
                if (!ConsentHelper.isTransactionalConsent())
                  getConsentStatus(
                      phone: phone,
                      showConsentStatus: showConsentStatus
                  )
              ],
            ),
            if (ConsentHelper.isTransactionalConsent()) ...{
              const SizedBox(
                height: 10,
              ),
              getConsentStatus(
                  phone: phone,
                  showConsentStatus: showConsentStatus
              )
            }
          ],
        ),
        icons: [
          JPTextButton(
            onPressed: () {
              Helper.launchCall(phone!.number!);
            },
            icon: Icons.phone,
            iconSize: 22,
            color: JPAppTheme.themeColors.primary,
          ),
          const SizedBox(
            width: 12,
          ),
          JPSaveMessageLog(
            phone: phone?.number?? '',
            consentStatus: phone?.consentStatus,
            overrideConsentStatus: false,
            phoneModel: phone,
            customerModel: customer,
          )
        ]
    );
  }

  Widget emailTile({required String title, int? jobId}) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        JPText(
          text: title,
          textAlign: TextAlign.start,
        ),
        if(jobId != null) ...{
          JPEmailButton(
            jobId: jobId,
            fullName: title,
            email: title,
          )
        } else...{
          JPEmailButton(
            fullName: title,
            email: title,
          )
        }
      ],
    );
  }

  Widget additionalDetailsTile({required String title, required String subTitle}) {
    return tileWrapper(
      title: title,
      subTitle: JPText(
        text: subTitle,
      ),
    );
  }

  Widget getConsentStatus({
    bool showConsentStatus = false,
    PhoneModel? phone,
  }) {
    return Visibility(
        visible: showConsentStatus,
        child:ConsentStatus(
          params: ConsentStatusParams(
            padding: const EdgeInsets.only(left: 8),
            phoneConsentDetail: phone,
            additionalEmails: customer?.additionalEmails,
            email: customer?.email,
            customerId: customer?.id,
            updateScreen: updateScreen,
            customer: customer
          ),
        )
    );
  }

}
