import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/extensions/scroll/no_scroll_physics.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/indexed_stack/index.dart';
import 'package:jobprogress/modules/project/project_form/form/index.dart';
import 'package:jobprogress/modules/project/project_form_tab/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ProjectFormTab extends StatefulWidget {
  const ProjectFormTab({
    super.key,
    required this.job,
    required this.fields,
    required this.formData,
    required this.isSaving,
    required this.formType,
    required this.divisionCode,
    required this.showHover,
    required this.showCompanyCam,
    required this.parentFormType,
  });

  /// [fields] contains the list of fields to be displayed
  final List<InputFieldParams> fields;
  final bool isSaving;
  final JobFormType formType;
  final String divisionCode;
  final bool? showHover;
  final bool? showCompanyCam;
  final JobModel? job;
  final List<Map<String, dynamic>> formData;
  final ParentFormType parentFormType;

  @override
  State<ProjectFormTab> createState() => ProjectFormTabState();
}

class ProjectFormTabState extends State<ProjectFormTab> {
  late ProjectTabController controller;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectTabController>(
      init: ProjectTabController(widget.fields, widget.formData, widget.formType, widget.divisionCode),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      didUpdateWidget: (controller, state) {
        state.controller?.divisionCode = widget.divisionCode;
      },
      global: false,
      builder: (controller) {
        return JPExpansionTile(
          enableHeaderClick: true,
          preserveWidgetOnCollapsed: true,
          initialCollapsed: controller.isSectionExpanded,
          borderRadius: controller.uiHelper.sectionBorderRadius,
          isExpanded: controller.isSectionExpanded,
          onExpansionChanged: controller.onSectionExpansionChanged,
          headerPadding: EdgeInsets.symmetric(
            horizontal: controller.uiHelper.horizontalPadding,
            vertical: controller.uiHelper.verticalPadding,
          ),
          header: Row(
            children: [
              Expanded(
                child: JPText(
                  text: 'project_information'.tr.toUpperCase(),
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                  textColor: JPAppTheme.themeColors.darkGray,
                  textAlign: TextAlign.start,
                ),
              ),
              JPAddRemoveButton(
                isDisabled: widget.isSaving,
                iconSize: 14,
                onTap: controller.onAddProject,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          trailing: (_) => JPIcon(
            Icons.expand_more,
            color: JPAppTheme.themeColors.secondaryText,
          ),
          children: [
            Transform.translate(
              offset: const Offset(0, -16),
              child: Visibility(
                visible: controller.projectCount != 1,
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Divider(
                          thickness: 2,
                          height: 1,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: controller.isExpandable,
                                builder: (_, bool isExpandable, child) {
                                  return isExpandable
                                      ? child!
                                      : const SizedBox();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: JPAppTheme.themeColors.lightBlue,
                                  child: JPTextButton(
                                    icon: Icons.chevron_left_rounded,
                                    color: JPAppTheme.themeColors.primary,
                                    padding: 0,
                                    iconSize: 18,
                                    iconPosition: JPPosition.start,
                                    onPressed: controller.scrollBackward,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ScrollConfiguration(
                                  behavior: NoScrollPhysics(),
                                  child: SingleChildScrollView(
                                    controller: controller.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                          controller.projectCount, (index) {
                                            return AutoScrollTag(
                                              index: index,
                                              key: Key("$index"),
                                              controller: controller.scrollController,
                                              child: InkWell(
                                                onTap: () => controller.onTabPresses(index),
                                                splashColor: JPAppTheme.themeColors.lightBlue,
                                                highlightColor: JPAppTheme.themeColors.lightBlue,
                                                borderRadius: BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8
                                                  ),
                                                  child: IntrinsicWidth(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            vertical: 6
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              JPText(text:"Project ${index + 1}"),
                                                              const SizedBox(
                                                                width: 2,
                                                              ),
                                                              JPTextButton(
                                                                icon: Icons.remove_circle_outline,
                                                                color: JPAppTheme.themeColors.secondary,
                                                                iconSize: 18,
                                                                padding: 2,
                                                                onPressed: () {
                                                                  controller.onRemoveProject(index);
                                                                  controller.update();
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 2.5,
                                                          thickness: 2.5,
                                                          color: index == controller.selectedIndex
                                                              ? JPAppTheme.themeColors.primary
                                                              : JPColor.transparent,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                      }),
                                    ),
                                  ),
                                )
                              ),
                              ValueListenableBuilder(
                                valueListenable: controller.isExpandable,
                                builder: (_, bool isExpandable, child) {
                                  return isExpandable
                                      ? child!
                                      : const SizedBox();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: JPAppTheme.themeColors.lightBlue,
                                  child: JPTextButton(
                                    icon: Icons.chevron_right_rounded,
                                    color: JPAppTheme.themeColors.primary,
                                    padding: 0,
                                    iconSize: 18,
                                    onPressed: controller.scrollForward,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            JPIndexedStack(
              index: controller.selectedIndex,
              children: projects(controller),
            ),
          ],
        );
      },
    );
  }

  Widget getTab(ProjectTabController controller, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          JPText(text:"Project $count"),
          const SizedBox(
            width: 2,
          ),
          JPTextButton(
            icon: Icons.remove_circle_outline,
            color: JPAppTheme.themeColors.secondary,
            iconSize: 18,
            padding: 2,
            onPressed: () {
              controller.onRemoveProject(count - 1);
              controller.update();
            },
          )
        ],
      ),
    );
  }

  List<Widget> projects(ProjectTabController controller) {
    controller.project = controller.projectWithKey
        .map((e) => Padding(
              padding: EdgeInsets.only(
                left: controller.uiHelper.horizontalPadding,
                right: controller.uiHelper.horizontalPadding,
                bottom: controller.uiHelper.verticalPadding,
              ),
              child: ProjectForm(
                  controller: null,
                  parentFormType: widget.parentFormType,
                  showCompanyCam: widget.showCompanyCam,
                  showHover: widget.showHover,
                  fields: e.fields,
                  job: widget.job,
                  key: e.key,
                  isSaving: widget.isSaving,
                  divisionCode: widget.divisionCode),
            )).toList();
    controller.update();
    return controller.project;
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidate: scrollOnValidate);
  }

  List<Map<String, dynamic>> data() {
    return controller.fetchProjectData();
  }
}
