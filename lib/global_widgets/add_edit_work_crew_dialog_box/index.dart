import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';


class AddEditWorkCrewDialogBox extends StatelessWidget {
  const AddEditWorkCrewDialogBox({
    super.key,
    required this.companyCrewList,
    required this.subcontractorList,
    required this.dialogController,
    required this.jobModel,
    this.tagList,

    required this.onFinish,
  });
  
  final JPBottomSheetController dialogController;
  final List<JPMultiSelectModel> companyCrewList;
  final List<JPMultiSelectModel> subcontractorList;
  final List<JPMultiSelectModel>? tagList;
  final JobModel jobModel;
  final Function(NoteListModel noteListModel) onFinish;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<AddEditWorkCrewDialogBoxController>(
          init: AddEditWorkCrewDialogBoxController(
            companyCrewList: companyCrewList, subcontractorList: subcontractorList,
            jobModel: jobModel, onFinish: onFinish,tagList: tagList),
          global: false,
          builder: (controller) {
            return AlertDialog(
            insetPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            contentPadding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      JPText(
                        text:'${'add_work_crew'.tr.toUpperCase()} ${controller.jobModel?.division != null ? '(${controller.jobModel?.division!.name.toString().toUpperCase()})' : ''}',
                        fontWeight: JPFontWeight.medium,
                        textSize: JPTextSize.heading3),
                      JPTextButton(
                        isDisabled: dialogController.isLoading,
                        onPressed: () => controller.reset(),
                        icon: Icons.close,
                        iconSize: 24,)
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// company_crew
                          Padding(
                            padding: EdgeInsets.only(
                              top: controller.formUiHelper.inputVerticalSeparator),
                            child: JPChipsInputBox<AddEditWorkCrewDialogBoxController>(
                              inputBoxController: controller.companyCrewController,
                              label: 'company_crew'.tr.capitalize,
                              isRequired: false,
                              controller: controller,
                              disabled: dialogController.isLoading,
                              selectedItems: controller.selectedCompanyCrew,
                              onTap: controller.selectCompanyCrew,
                              onRemove: (user) => controller.removeSelectedWorkCrew(user),
                            ),
                          ),

                          /// Labor / Sub Contractors
                          Padding(
                            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
                            child: JPChipsInputBox<AddEditWorkCrewDialogBoxController>(
                              inputBoxController: controller.labourContractorsController,
                              label: 'labor_sub_contractors'.tr,
                              isRequired: false,
                              controller: controller,
                              disabled: dialogController.isLoading,
                              selectedItems: controller.selectedLaborContractors,
                              onTap: controller.selectLabourContractors,
                              onRemove: (user) => controller.removeSelectedWorkCrew(user),
                            ),
                          ),
                          const SizedBox(height: 25,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: JPResponsiveDesign.popOverButtonFlex,
                        child: JPButton(
                          onPressed: ()=> controller.reset(),
                          disabled: dialogController.isLoading,
                          size: JPButtonSize.small,
                          text: 'cancel'.tr.toUpperCase(),
                          colorType: JPButtonColorType.lightGray
                        )
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        flex: JPResponsiveDesign.popOverButtonFlex,
                        child: JPButton(
                          onPressed: () async{
                            FocusManager.instance. primaryFocus?.unfocus();
                            dialogController.toggleIsLoading();
                            await controller.onTapSave();
                            dialogController.toggleIsLoading();
                          },
                          iconWidget: showJPConfirmationLoader(show: dialogController.isLoading),
                          disabled: dialogController.isLoading,
                          size: JPButtonSize.small,
                          text: dialogController.isLoading ?
                          '' : 'save'.tr.toUpperCase()),
                      )
                    ],
                  )
                ],
              ),
            )
          );
          }
        ),
      ),
    );
  }
}
