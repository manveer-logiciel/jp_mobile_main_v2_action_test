import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/contact_person/tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormContactPerson extends StatelessWidget {
  const JobFormContactPerson({
    super.key,
    required this.controller
  });

  final JobFormController controller;

  JobFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Transform.translate(
          offset: const Offset(0, -4),
          child: JPCheckbox(
            key: const Key(WidgetKeys.sameAsCustomerKey),
            selected: service.isContactPersonSameAsCustomer,
            padding: const EdgeInsets.symmetric(
              horizontal: 10
            ),
            onTap: service.toggleContactSameAsCustomer,
            disabled: controller.isSavingForm,
            text: "same_as_customer".tr,
            separatorWidth: 2,
          ),
        ),


        if (!service.isContactPersonSameAsCustomer)
          ListView.separated(
              padding: const EdgeInsets.only(
                top: 5
              ),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_, index) {
                return JobFormContactPersonTile(
                  data: service.contactPersons[index],
                  onTapEdit: () => service.onAddEditContactPerson(index: index),
                  onTapDelete: () => service.onDeleteContactPerson(index: index),
                  isDisabled: controller.isSavingForm,
                );
              },
              separatorBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 16
                  ),
                  child: Divider(
                    color: JPAppTheme.themeColors.dimGray,
                    thickness: 1,
                    height: 1,
                  ),
                );
              },
              itemCount: service.contactPersons.length,
          ),
      ],
    );
  }
}
