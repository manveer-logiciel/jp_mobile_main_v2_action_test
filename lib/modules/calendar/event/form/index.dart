import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/calendar/event/form/sections/attachment_section.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/enums/form_field_type.dart';
import '../../../../common/models/forms/event/event_form_param.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/form_builder/index.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../schedule/details/widgets/attachments.dart';
import '../../../schedule/details/widgets/workcrew_notes.dart';
import '../controller.dart';
import 'sections/additional_options_section.dart';
import 'sections/event_details.dart';

class EventForm extends StatelessWidget {
  const EventForm({
    super.key,
    this.eventFormParam,
  });

  final EventFormParams? eventFormParam;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => eventFormParam?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<EventFormController> (
      init: eventFormParam?.controller ?? EventFormController(eventFormParam: eventFormParam),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPFormBuilder(
            title: controller.pageTitle,
            onClose: controller.onWillPop,
            form: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EventDetailsSection(controller: controller),
                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: Padding(
                      padding: EdgeInsets.only(top : controller.formUiHelper.sectionSeparator),
                      child: AdditionalOptionsSection(controller: controller),
                    ),
                  ),
                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: Padding(
                      padding: EdgeInsets.only(top : controller.formUiHelper.sectionSeparator),
                      child: ScheduleDetailWorkCrewNotes(
                        workCrewNote: controller.schedulesModel?.workCrewNote ?? [],
                        pageType: controller.pageType,
                        onSelect: controller.service.selectWorkNote,
                        onAdd: controller.service.createWorkNote,
                        isDisabled: !controller.service.isFieldEditable(FormFieldType.workCrewNotes),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: Padding(
                      padding: EdgeInsets.only(top : controller.formUiHelper.sectionSeparator),
                      child: ScheduleDetailAttachments(
                        title: 'work_orders'.tr.toUpperCase(),
                        tapHereText: 'to_select_work_order'.tr,
                        attachments: controller.schedulesModel?.workOrder ?? [],
                        isEdit: true,
                        addCallback: controller.service.addWorkOrderAttachment,
                        onSelect: controller.service.addWorkOrderAttachment,
                        onTapCancelIcon: controller.service.removeWorkOrderAttachment,
                        isDisabled: !controller.service.isFieldEditable(FormFieldType.workOrders),
                      ),
                    ),
                  ),

                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: Padding(
                      padding: EdgeInsets.only(top : controller.formUiHelper.sectionSeparator),
                      child: ScheduleDetailAttachments(
                        title: 'materials'.tr.toUpperCase(),
                        tapHereText: 'to_select_materials'.tr,
                        attachments: controller.schedulesModel?.materialList ?? [],
                        isEdit: true,
                        addCallback: controller.service.addMaterialAttachment,
                        onSelect: controller.service.addMaterialAttachment,
                        onTapCancelIcon: controller.service.removeMaterialAttachment,
                        isDisabled: !controller.service.isFieldEditable(FormFieldType.materials),
                      ),
                    ),
                  ),

                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: Padding(
                      padding: EdgeInsets.only(top : controller.formUiHelper.sectionSeparator),
                      child: AttachmentSection(controller: controller,),
                    ),
                  ),

                  Visibility(
                    visible: controller.service.isScheduleForm,
                    child: SizedBox(height: controller.formUiHelper.sectionSeparator)),

                  SizedBox(height: controller.formUiHelper.sectionSeparator),
                ],
              ),
            ),
            footer: JPButton(
              type: JPButtonType.solid,
              text: controller.isSavingForm
                  ? ""
                  : controller.saveButtonText,
              size: JPButtonSize.small,
              disabled: controller.isSavingForm,
              suffixIconWidget: showJPConfirmationLoader(
                show: controller.isSavingForm,
              ),
              onPressed: controller.createEvent,
            ),
            inBottomSheet: isBottomSheet,
          ),
        );
      }),
    );
  }
}
