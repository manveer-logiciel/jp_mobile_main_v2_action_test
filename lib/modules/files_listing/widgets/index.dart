
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/bread_crumb/index.dart';
import 'package:jobprogress/global_widgets/html_viewer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/option_list/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_grid_view.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_list_view.dart';
import 'package:jobprogress/modules/files_listing/widgets/secondary_header.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/services/files_listing/quick_action_handlers.dart';
import '../../../core/constants/urls.dart';
import '../../../core/utils/helpers.dart';
import 'cumulative_invoice_secondry_header.dart';

class FilesView extends StatelessWidget {
  const FilesView({
    super.key,
    required this.controller,
    this.onTapMove,
    this.onTapAttach,
    this.onTapUnFavourite,
    this.tag
  });

  final FilesListingController controller;

  final VoidCallback? onTapMove;

  final Function(List<FilesListingModel> seletecedFiles)? onTapAttach;
  final Function(List<FilesListingModel> seletecedFiles)? onTapUnFavourite;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: controller.isNotInDefaultMode() ? JPResponsiveDesign.bottomSheetRadius : null,
        child: JPSafeArea(
          bottom: controller.isNotInDefaultMode(),
          child: Column(
            children: [
              if(controller.doShowSecondaryHeader())
              JPSecondaryHeader(
                customerId: controller.customerId!,
                currentJob: controller.jobModel,
                type: controller.type,
                onJobPressed: controller.handleChangeJob,
                onTap: () => controller.scaffoldKey.currentState!.openDrawer(),
              ),
              if(controller.doShowModuleName && !controller.isNotInDefaultMode())
              Container(
                width: double.maxFinite,
                color: JPAppTheme.themeColors.inverse,
                padding: const EdgeInsets.only(top: 10, left: 11, right: 11, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Material(
                        color: JPColor.transparent,
                        child: InkWell(
                          onTap: controller.canFilterByModule ? () => controller.openModuleNameFilters() : null,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: JPText(
                                  text: controller.getModuleNameWithCount(),
                                  textAlign: TextAlign.start,
                                  fontWeight: JPFontWeight.medium,
                                  textSize: JPTextSize.heading4
                                  
                                ),
                              ),
                              if(controller.canFilterByModule)... {
                                const JPIcon(Icons.keyboard_arrow_down)
                              },
                            ],
                          ),
                        ),
                      ),
                    ),

                  if(controller.type == FLModule.jobProposal)
                    Flexible(
                      child: JPButton(
                        text: 'legal_disclaimer'.tr.toUpperCase(),
                        size: JPButtonSize.size24,
                        onPressed: () => Helper.launchUrl(Urls.disclaimerURL),
                      ),
                    ),
                  if (controller.showMoreAction) ...{
                    Opacity(
                      opacity: !controller.isInSelectionMode ? 1 : 0,
                      child: AbsorbPointer(
                        absorbing: controller.isInSelectionMode,
                        child: JPPopUpMenuButton(
                          popUpMenuButtonChild: JPIcon(Icons.more_vert_outlined, color: JPAppTheme.themeColors.text),      
                          itemList: FilesListingService.getPhotoDocMoreAcion(jobModel: controller.jobModel),
                          popUpMenuChild: (value) {
                            return JPOptionsList(value: value.label,icon: value.icon);
                          },
                          onTap: (selected) => controller.onPopUpMenuItemTap(selected),
                        ),
                      ),
                    ),
                  }
                ],
              ),
            ),
              if(controller.type == FLModule.instantPhotoGallery && !controller.isNotInDefaultMode()) InstantPhotoGallerySecondaryHeader(controller: controller,),
              if(controller.type == FLModule.financialInvoice)
              CumulativeInvoiceSecondaryHeader(controller: controller,),
              Expanded(
                child: Column(
                  children: [
                    if(controller.type != FLModule.financialInvoice)
                    modeToHeader(),
                    typeToView(),
                  ],
                ),
              ),
              if (controller.isNotInDefaultMode())
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 12, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      getPrefixButton(),
                      if(controller.type == FLModule.favouriteListing) ...{
                        const SizedBox(
                          width: 12,
                        ),
                        getEditButton(),
                      },
                      const SizedBox(
                        width: 12,
                      ),
                      getSuffixButton(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget typeToSearchBar() {
    switch (controller.type) {
      case FLModule.companyFiles:
        return searchBar();
      case FLModule.templates:
      case FLModule.templatesListing:
      case FLModule.googleSheetTemplate:
        return searchBar();
      case FLModule.mergeTemplate:
        return searchBar();
      case FLModule.userDocuments:
        return searchBar();
      case FLModule.dropBoxListing:
        return searchBar();
      case FLModule.stageResources:
        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 4
                  ),
                  child: Row(
                    children: [
                      ActionChip(
                        label: JPText(
                          text: 'stage_resources'.tr,
                          textColor: !controller.isGoalSelected
                              ? JPAppTheme.themeColors.primary
                              : JPAppTheme.themeColors.text,
                        ),
                        onPressed: () {
                          controller.toggleIsGoalSelected(false);
                        },
                        backgroundColor: !controller.isGoalSelected
                            ? JPAppTheme.themeColors.lightBlue
                            : JPAppTheme.themeColors.dimGray,
                        pressElevation: 0,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ActionChip(
                        label: JPText(
                            text: 'goal'.tr,
                            textColor: controller.isGoalSelected
                                ? JPAppTheme.themeColors.primary
                                : JPAppTheme.themeColors.text),
                        onPressed: () {
                          controller.toggleIsGoalSelected(true);
                        },
                        pressElevation: 0,
                        backgroundColor: controller.isGoalSelected
                            ? JPAppTheme.themeColors.lightBlue
                            : JPAppTheme.themeColors.dimGray,
                      ),
                    ],
                  ),
                ),
              ),
              JPFilterIcon(
                onTap: controller.isLoading ? null : () {
                  controller.showStageResourceFilters();
                },
              ),
            ],
          ),
        );
      case FLModule.companyCamProjects:
        return searchBar();
      default:
        return const SizedBox.shrink();
    }
  }

  bool doShowBreadCrumb() {
    if(controller.isInSelectionMode && controller.type == FLModule.companyCamProjects) {
      return false;
    }
    switch (controller.type) {
      case FLModule.stageResources:
        return false;
      case FLModule.instantPhotoGallery:
        return false;
      default:
        return controller.doSupportFolderStructure;
    }
  }

  Widget modeToHeader() {
    if(controller.isInMoveFileMode! || controller.mode == FLViewMode.copy || controller.mode == FLViewMode.moveToJob) {
      return moveFileModeHeader();
    } else if(controller.mode == FLViewMode.attach || controller.mode == FLViewMode.apply) {
      return attachFileModeHeader();
    } else {
      return defaultHeader();
    }
  }

  Widget moveFileModeHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        // header title and cancel icon
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: JPText(
                  text: controller.type == FLModule.estimate
                      ? "estimates".tr.toUpperCase()
                      : controller.type == FLModule.jobProposal
                      ? "form_proposals".tr.toUpperCase()
                      : 'choose_destination'.tr.toUpperCase(),
                  fontWeight: JPFontWeight.bold,
                  textSize: JPTextSize.heading3,
                  textAlign: TextAlign.start,
                ),
              ),
              JPTextButton(
                icon: Icons.close,
                iconSize: 22,
                color: JPAppTheme.themeColors.text,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget attachFileModeHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        // header title and cancel icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: JPText(
                  text: controller.attachmentHeaderTitle(),
                  fontWeight: JPFontWeight.bold,
                  textSize: JPTextSize.heading3,
                  textAlign: TextAlign.start,
                ),
              ),
              if(controller.allowMultipleSelection)
                JPButton(
                  size: JPButtonSize.extraSmall,
                  type: JPButtonType.outline,
                  text: 'reset'.tr,
                  onPressed: controller.showResetSelectionDialog,
                  disabled: controller.selectedFileCount == 0 || controller.isLoading || controller.resourceList.isEmpty,
                ),
              const SizedBox(
                width: 8,
              ),
              if(controller.type == FLModule.stageResources)...{
                Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: JPFilterIcon(
                      onTap: () {
                        controller.showStageResourceFilters();
                      },
                    )),
              },
              if(controller.selectedFileCount != 0 && controller.type ==  FLModule.favouriteListing && controller.resourceList.isNotEmpty)...{
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: JPButton(
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    text: 'unfavourite'.tr.toUpperCase(),
                    onPressed: controller.unFavoriteEstimate,
                  ),
                ),
              },

              if(controller.type == FLModule.favouriteListing)...{
                JPFilterIcon(
                    type: JPFilterIconType.button,
                    onTap: (){
                      controller.openTradeFilterDialog();
                    }
                ),
              },

              JPTextButton(
                icon: Icons.close,
                iconSize: 22,
                color: JPAppTheme.themeColors.text,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
        if (controller.searchController.text == "" && doShowBreadCrumb())
          JPBreadCrumb<String>(
            pathList: controller.folderPath.map((e) => e.name).toList(),
            collapseAt: controller.collapseAt,
            height: 30,
            onTapPath: controller.isLoading ? null : (val) { controller.onTapBreadCrumbItem(val);},
            addToPopUp: controller.handleBreadCrumbOverFlow,
          ),
      ],
    );
  }

  Widget defaultHeader() {
    return Column(
      children: [
        typeToSearchBar(),
        if (doShowBreadCrumb())
          const SizedBox(
            height: 8,
          ),
        if (controller.searchController.text == "" && doShowBreadCrumb())
          JPBreadCrumb<String>(
            pathList: controller.folderPath.map((e) => e.name).toList(),
            collapseAt: controller.collapseAt,
            height: 30,
            onTapPath: controller.isLoading
                ? null
                : (val) {
              controller.onTapBreadCrumbItem(val);
            },
            addToPopUp: controller.handleBreadCrumbOverFlow,
          ),
      ],
    );
  }

  Widget typeToView() {
    if (controller.isGoalSelected) {
      if (controller.currentGoal == null || controller.currentGoal!.isEmpty) {
        return  Expanded(
          child: NoDataFound(
            icon: Icons.task,
            title: 'no_description_found'.tr,
          ),
        );
      } else {
        return Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12
              ),
              child: JPHtmlViewer(
                htmlContent: controller.currentGoal.toString(),
              ),
            ),
          ),
        );
      }
    } else {
      return controller.showListView || controller.isInMoveFileMode! || controller.type == FLModule.companyCamProjects || controller.mode == FLViewMode.copy || controller.mode == FLViewMode.moveToJob
          ? FilesListView(controller: controller)
          : FilesGridView(controller: controller);
    }
  }

  Widget searchBar() => Padding(
    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        JPInputBox(
          type: JPInputBoxType.searchbar,
          hintText: 'search'.tr,
          fillColor: JPAppTheme.themeColors.base,
          controller: controller.searchController,
          debounceTime: 700,
          onChanged: controller.onSearchChanged,
        ),
        if (controller.searchController.text.isNotEmpty && controller.totalResults != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: JPText(
              text: '${controller.totalResults} ${controller.totalResults == 1 ? 'result'.tr : 'results'.tr}',
              textColor: JPAppTheme.themeColors.darkGray,
              textSize: JPTextSize.heading5,
            ),
          ),
      ],
    ),
  );

  Widget getSuffixButton() {
    if(controller.isInMoveFileMode!) {
      return Expanded(
        flex: JPResponsiveDesign.popOverButtonFlex,
        child: JPButton(
          text: controller.isMovingFile ? '' : 'move'.tr.toUpperCase(),
          onPressed: controller.isMovingFile ? null : onTapMove,
          size: JPButtonSize.small,
          disabled: controller.isMovingFile || controller.isLoading || controller.resourceList.isEmpty,
          iconWidget: showJPConfirmationLoader(show: controller.isMovingFile),
        ),
      );
    } else {
      String buttonText = controller.type == FLModule.dropBoxListing
          ? 'upload'.tr.toUpperCase()
          : 'attach'.tr.toUpperCase();
      switch (controller.mode) {
        case FLViewMode.apply:
          return Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              text: controller.isMovingFile ? '' : 'apply'.tr,
              onPressed: onTapAttach == null ? null : () => onTapAttach!(controller.getSelectedFiles()),
              size: JPButtonSize.small,
              disabled: controller.selectedFileCount == 0 ||
                  controller.isLoading ||
                  controller.resourceList.isEmpty ||
                  controller.isMovingFile ||
                  (controller.type == FLModule.measurements &&
                      (controller.resourceList[controller.lastSelectedFile??-1].totalValues ?? 0) == 0)
                    || (controller.type == FLModule.favouriteListing && controller.isSelectedWorksheetSame()),
              iconWidget: showJPConfirmationLoader(show: controller.isMovingFile),
            ),
          );

        case FLViewMode.attach:
          return Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              key: const ValueKey(WidgetKeys.flBottomSheetConfirmButtonKey),
              text: controller.suffixIconText ?? (controller.isMovingFile ? '' : buttonText),
              onPressed: onTapAttach == null ? null : () => onTapAttach!(controller.getSelectedFiles()),
              size: JPButtonSize.small,
              disabled: controller.selectedFileCount == 0 || controller.isLoading || controller.resourceList.isEmpty || controller.isMovingFile,
              iconWidget: showJPConfirmationLoader(show: controller.isMovingFile),
            ),
          );
        case FLViewMode.copy:
          return Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              text: controller.isMovingFile ? '' : 'copy_here'.tr.toUpperCase(),
              onPressed: (onTapAttach == null || controller.isMovingFile) ? null : () => onTapAttach!(controller.getSelectedFiles()),
              size: JPButtonSize.small,
              disabled: controller.isMovingFile || controller.isLoading ,
              iconWidget: showJPConfirmationLoader(show: controller.isMovingFile),
            ),
          );
        case FLViewMode.moveToJob:
          return Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              text: controller.isMovingFile ? '' : 'move_here'.tr.toUpperCase(),
              onPressed: (onTapAttach == null || controller.isMovingFile) ? null : () => onTapAttach!(controller.getSelectedFiles()),
              size: JPButtonSize.small,
              disabled: controller.isMovingFile || controller.isLoading || controller.resourceList.isEmpty,
              iconWidget: showJPConfirmationLoader(show: controller.isMovingFile),
            ),
          );
        default:
          return const SizedBox.shrink();
      }

    }
  }
  Widget getPrefixButton() {
    switch (controller.mode) {
      case FLViewMode.apply:
        return Expanded(
          flex: JPResponsiveDesign.popOverButtonFlex,
          child: JPButton(
            text: 'view'.tr.toUpperCase(),
            onPressed: () {
              final file = controller.resourceList[controller.lastSelectedFile!];
              FileListQuickActionHandlers.downloadAndOpenFile(file.originalFilePath ?? '', classType: file.classType);
            },
            colorType: JPButtonColorType.lightGray,
            size: JPButtonSize.small,
            disabled: controller.isMovingFile || controller.lastSelectedFile == null,
          ),
        );
      default:
        return Expanded(
          flex: JPResponsiveDesign.popOverButtonFlex,
          child: JPButton(
            text: 'cancel'.tr.toUpperCase(),
            onPressed: () {Get.back();},
            colorType: JPButtonColorType.lightGray,
            size: JPButtonSize.small,
            disabled: controller.isMovingFile,
          ),
        );
    }
  }

  Widget getEditButton() {
    return Expanded(
      flex: JPResponsiveDesign.popOverButtonFlex,
      child: JPButton(
        text: 'edit'.tr.toUpperCase(),
        onPressed: () {
          controller.tapOnEditFavouriteWorksheet();
        },
        colorType: JPButtonColorType.lightGray,
        size: JPButtonSize.small,
        disabled: (controller.isMovingFile || controller.lastSelectedFile == null) || (controller.type == FLModule.favouriteListing && controller.isSelectedWorksheetSame()),
      ),
    );
  }
}
