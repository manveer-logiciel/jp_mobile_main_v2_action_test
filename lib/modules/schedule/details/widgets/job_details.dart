import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/user_list_for_popover/index.dart';
import 'package:jobprogress/modules/schedule/details/widgets/chip_status_widget_.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleJobDetail extends StatelessWidget {
  ScheduleJobDetail({
    required this.scheduleDetail, 
    required this.job, 
    super.key, 
    this.updateScreen});
  
  final SchedulesModel scheduleDetail;
  final JobModel job;
  final VoidCallback? updateScreen; 

  Widget getTitle(String title) {
    return JPText(
      text: title,
      textAlign: TextAlign.left,
      textColor: JPAppTheme.themeColors.tertiary,
      textSize: JPTextSize.heading5,
    );
  }

  Widget getWidget(String title, String subTitle, 
      {IconData? firstIcon, IconData? secondIcon, Widget? emailButton}) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTitle(title),
                        const SizedBox(
                          height: 6,
                        ),
                        JPText(
                          text: subTitle,
                          textColor: JPAppTheme.themeColors.text,
                        ),
                      ],
                    ),
                    if(firstIcon != null || secondIcon != null || emailButton != null)
                    Row(
                      children: [
                        if(secondIcon != null)
                        JPIcon(secondIcon, color: JPAppTheme.themeColors.primary),
                        const SizedBox(
                          width: 20,
                        ),
                        if(firstIcon != null)
                        JPIcon(
                          firstIcon,
                          color: JPAppTheme.themeColors.primary,
                        ),
                        if(emailButton != null)
                        emailButton  
                      ],
                    ),  
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            )),
        Divider(
          height: 0,
          thickness: 1,
          color: JPAppTheme.themeColors.dimGray,
        ),
      ],
    );
  }

  final List<Widget> phoneList = [];

  List<Widget> getPhones() {
    phoneList.clear();
    if(scheduleDetail.customer?.phones != null) {
      for (int i = 0; i < scheduleDetail.customer!.phones!.length; i++) {
        phoneList.add(getPhoneWidget(
          scheduleDetail.customer!.phones![i],
          showConsentStatus: true,
        )
        );
      }
    }
    return phoneList;
  }

  Widget getPhoneWidget(
    PhoneModel phone,
    {required bool showConsentStatus}
  ) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 11, top: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTitle(phone.label?.tr.capitalize ?? 'phone'.tr.capitalize!),
                          const SizedBox(
                            height: 6,
                          ),
                          Wrap(
                            runSpacing:5,
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              JPText(text: PhoneMasking.maskPhoneNumber(phone.number!)),
                              if (!Helper.isValueNullOrEmpty(phone.ext))...{
                               
                                JPText(
                                  text: 'Ext: ',
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                                JPText(text: phone.ext!),
                              },
                              if (!ConsentHelper.isTransactionalConsent())
                                getConsentStatus(
                                  showConsentStatus: showConsentStatus,
                                  phone: phone
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        JPSaveCallLog(callLogs: CallLogCaptureModel(
                          customerId: scheduleDetail.customer!.id!,
                          phoneLabel: phone.label ?? 'phone'.tr, 
                          phoneNumber: phone.number!,
                        )),                              
                        const SizedBox(
                          width: 10,
                        ),
                        JPSaveMessageLog(
                          phone: phone.number!,
                          consentStatus: phone.consentStatus,
                          overrideConsentStatus: false,
                          phoneModel: phone,
                          customerModel: scheduleDetail.customer,
                        )
                      ],
                    )
                  ],
                ),
                if (ConsentHelper.isTransactionalConsent()) ...{
                  const SizedBox(
                    height: 10,
                  ),
                  getConsentStatus(
                      showConsentStatus: showConsentStatus,
                      phone: phone
                  ),
                },
                const SizedBox(
                  height: 16,
                ),
              ],
            )),
        Divider(
          height: 0,
          thickness: 1,
          color: JPAppTheme.themeColors.dimGray,
        ),
      ],
    );
  }

  Widget getLabelValue(String title, Widget widget) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(title),
              const SizedBox(
                height: 6,
              ),
              widget,
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
        Divider(
          color: JPAppTheme.themeColors.dimGray,
          height: 0,
          thickness: 1,
        )
      ],
    );
  }

  Widget getSalesmanRep() {
    return  Row(
      children: [
        JPProfileImage(
          src: scheduleDetail.customer!.rep!.profilePic,
          color: scheduleDetail.customer!.rep!.color,
          initial: scheduleDetail.customer!.rep!.intial,
        ),
        const SizedBox(
          width: 5,
        ),
        JPText(
          text: scheduleDetail.customer!.rep!.fullName,
          fontWeight: JPFontWeight.medium,
        ),
      ],
    );
  }

  String getJobName() {
    if (job.divisionCode != null && job.divisionCode!.isNotEmpty) {
      return '${job.divisionCode}-${job.altId}';
    }
    
    return job.altId!;
  }

  Widget getParticipants(List<UserLimitedModel> workCrew) {
    int length = 5;

    if(workCrew.length < 5) {
      length = workCrew.length;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            runSpacing: 5.0,
            direction: Axis.horizontal,
            children: [
              for (int i = 0; i < length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ScheduleDetailWorkCrewChip(
                    workCrew: workCrew[i],
                  )
                ),
              if (workCrew.length > 5)
                Material(
                  color: JPColor.transparent,
                  child: JPPopUpMenuButton(
                    popUpMenuButtonChild: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
                      child: JPText(
                        text: '+${workCrew.length - 5} ${'more'.tr}',
                        textSize: JPTextSize.heading4,
                        fontWeight: JPFontWeight.medium,
                        textColor: JPAppTheme.themeColors.primary,
                      ),
                    ),
                    childPadding: const EdgeInsets.only(
                        left: 16, right: 16, top: 9, bottom: 9),
                    itemList: workCrew.sublist(5),
                    popUpMenuChild: (UserLimitedModel val) {
                      return UserListItemForPopMenuItem(user: val);
                    },
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  String getJobDuration() {
    String duration = job.duration!;

    if(duration.contains(":")) {
      final splittedDuration = duration.split(':');

      String days = (splittedDuration[0] != '0')
          ? (splittedDuration[0] == '1')
          ? '${splittedDuration[0]} ${'day'.tr}'
          : '${splittedDuration[0]} ${'days'.tr}'
          : '';

      String hours = (splittedDuration[1] != '0')
          ? (splittedDuration[1] == '1')
          ? '${splittedDuration[1]} ${'hour'.tr}'
          : '${splittedDuration[1]} ${'hours'.tr}'
          : '';

      String minutes = (splittedDuration[2] != '0')
          ? (splittedDuration[2] == '1')
          ? '${splittedDuration[2]} ${'minute'.tr}'
          : '${splittedDuration[2]} ${'minutes'.tr}'
          : '';

      return '$days  $hours $minutes';
    } else {
      return duration;
    }
  }

  Widget getJobDetailChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: getPhones(),
        ),
        if (Helper.isValueNullOrEmpty(scheduleDetail.customer?.email))
          getWidget(
            'email'.tr, scheduleDetail.customer!.email ?? '',
            emailButton: JPEmailButton(
              jobId: job.id,
            )
          ),
        if (job.altId != null && job.altId!.isNotEmpty)
          getWidget('${'job'.tr} #', getJobName()),

        if (job.name != null && job.name!.isNotEmpty) getWidget('job_name'.tr, job.name ?? ''),

        if (job.duration != null && job.duration!.isNotEmpty && job.duration != '0:0:0')
          getWidget('job_duration'.tr, getJobDuration()),
        
        if (job.division != null)
          getWidget('job_division'.tr, job.division!.name ?? ''),

        if (job.jobTypesString != null && job.jobTypesString!.isNotEmpty)
          getWidget('category'.tr, job.jobTypesString!),

        if (scheduleDetail.trades != null && scheduleDetail.trades!.isNotEmpty)
          getWidget('trade_type'.tr, scheduleDetail.trades![0].name ?? ''),

        if (scheduleDetail.customer != null && scheduleDetail.customer!.rep != null)
          getLabelValue('salesman_customer_rep'.tr, getSalesmanRep()),

        if (job.estimators != null && job.estimators!.isNotEmpty)
          getLabelValue('job_rep_estimator'.tr, getParticipants(job.estimators!)),
      ],
    );
  }

  Widget getConsentStatus({
    bool showConsentStatus = false,
    PhoneModel? phone,
  }) {
    return Visibility(
      visible: showConsentStatus,
      child: ConsentStatus(
        params: ConsentStatusParams(
          updateScreen: updateScreen,
          phoneConsentDetail: phone,
          email: scheduleDetail.customer?.email,
          additionalEmails: scheduleDetail.customer?.additionalEmails,
          customerId: scheduleDetail.customer?.id,
          customer: scheduleDetail.customer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: JPAppTheme.themeColors.base),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getJobDetailChildren(),
            ]
          ),
        ]
      ),
    );
  }
}
