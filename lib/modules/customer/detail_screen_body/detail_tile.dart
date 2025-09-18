import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomerDetailTile extends StatelessWidget {

  const CustomerDetailTile({
    super.key,
    required this.visibility,
    this.label,
    this.description,
    this.ext,
    this.imageURl,
    this.color,
    this.trailing,
    this.initial, 
    this.showConsentStatus = false,
    this.isDescriptionSelectable = false,
    this.customer, 
    this.phoneModel, 
    this.updateScreen});

  final bool visibility;
  final String? label;
  final String? description;
  final String? ext;
  final String? imageURl;
  final String? color;
  final Widget? trailing;
  final String? initial;
  final bool showConsentStatus;
  final bool isDescriptionSelectable;
  final CustomerModel? customer;
  final PhoneModel? phoneModel;
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visibility,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, ((imageURl != null) || (ext != null) || (description?.isNotEmpty ?? false)) ? 16 : 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: label?.isNotEmpty ?? false,
                      child: JPText(
                        text: label!,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: 6,),
                    imageURl != null
                        ? Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          JPProfileImage(
                            size: JPAvatarSize.small,
                            src: imageURl,
                            color: color,
                            initial:initial,
                          ),
                          Visibility(
                            visible: description?.isNotEmpty ?? false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: JPText(
                                  text: description ?? "",
                                  textAlign: TextAlign.start,
                                  textSize: JPTextSize.heading4,
                                  fontWeight: JPFontWeight.medium,
                                  isSelectable: isDescriptionSelectable,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : ext != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: description?.isNotEmpty ?? false,
                                  child: JPText(
                                    text: description ?? "",
                                    textAlign: TextAlign.start,
                                    textSize: JPTextSize.heading4,
                                    isSelectable: isDescriptionSelectable,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: ext?.isNotEmpty ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: JPText(
                                            text: "ext".tr,
                                            textAlign: TextAlign.start,
                                            textSize: JPTextSize.heading5,
                                            textColor: JPAppTheme.themeColors.tertiary,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: ext?.isNotEmpty ?? false,
                                        child: Flexible(
                                          child: JPText(
                                            text: ext ?? "",
                                            textAlign: TextAlign.start,
                                            textSize: JPTextSize.heading4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      if (!ConsentHelper.isTransactionalConsent())
                                        getConsentStatus(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Visibility(
                      visible: description?.isNotEmpty ?? false,
                      child: JPText(
                        text: description ?? "" ,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading4,
                        isSelectable: isDescriptionSelectable,
                      ),
                    ),

                    if (ConsentHelper.isTransactionalConsent()) ...{
                      const SizedBox(height: 10),
                      getConsentStatus(),
                    },
                  ],
                ),
              ),
              trailing ?? const SizedBox.shrink()
            ],
          ),
        )
    );
  }

  Widget getConsentStatus() {
    return Visibility(
      visible: showConsentStatus,
      child: ConsentStatus(
        params: ConsentStatusParams(
          padding: const EdgeInsets.only(left: 5),
          phoneConsentDetail: phoneModel,
          additionalEmails: customer?.additionalEmails,
          email: customer?.email,
          customerId: customer?.id,
          updateScreen: updateScreen,
          customer: customer
        ),
      ),
    );
  }
}
