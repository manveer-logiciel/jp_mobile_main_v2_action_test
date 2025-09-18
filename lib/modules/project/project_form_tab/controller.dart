import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/project_tab/index.dart';
import 'package:jobprogress/modules/project/project_form/form/index.dart';
import 'package:jobprogress/modules/project/project_form_tab/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ProjectTabController extends GetxController with GetTickerProviderStateMixin {
  ProjectTabController(this.fields, this.formData, this.formType, this.divisionCode);

  GlobalKey<ProjectFormTabState> key = GlobalKey<ProjectFormTabState>();

  final JobFormType formType;

  FormUiHelper uiHelper = JPAppTheme.formUiHelper;
  bool isSectionExpanded = false;

  List<Tab> tabs = [];
  List<Widget> project = [];
  List<ProjectTabModel> projectWithKey = [];

  List<InputFieldParams> fields;
  List<Map<String, dynamic>> formData;

  String divisionCode;

  int projectCount = 1;
  int selectedIndex = 0;

  double maxScrollExtent = 0.0;

  ValueNotifier<bool> isExpandable = ValueNotifier(false);

  AutoScrollController scrollController = AutoScrollController(
    axis: Axis.horizontal,
    initialScrollOffset: 0,
  );

  @override
  void onInit() {
    projectWithKey.add(ProjectTabModel(key: GlobalKey<ProjectFormState>(), fields: fields));
    update();

    super.onInit();
  }

  Future<void> hideShowScrollHelpers() async {
    // additional delay for ui to update
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (scrollController.hasClients && project.length > 2) {
      final widthToExclude = isExpandable.value ? 50 : 40;
      final result = scrollController.position.viewportDimension >= (JPScreen.width - widthToExclude);
      isExpandable.value = result;
    }
  }

  void scrollForward() {
    double scrollToOffset = scrollController.offset + (JPScreen.width - 45);
    scrollController.animateTo(scrollToOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void scrollBackward() {
    double scrollToOffset = scrollController.offset - (JPScreen.width - 45);
    scrollController.animateTo(scrollToOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onSectionExpansionChanged(bool val) {
    isSectionExpanded = val;
  }

  void onAddProject() {
    isSectionExpanded = true;
    projectCount++;
    projectWithKey.add(ProjectTabModel(key: GlobalKey<ProjectFormState>(), fields: fields));
    selectedIndex = projectCount - 1;
    update();
    hideShowScrollHelpers();
    scrollController.scrollToIndex(selectedIndex);
  }

  void onRemoveProject(int removeIndex) {
    projectCount--;
    projectWithKey.removeAt(removeIndex);
    selectedIndex = projectCount - 1;
    update();
    hideShowScrollHelpers();
  }

  TabController getTabController() {
    return TabController(length: projectCount, vsync: this, initialIndex: 0,);
  }

  void onTabPresses(int index) {
    selectedIndex = index;
    update();
  }

  bool validateForm({bool scrollOnValidate = true}) {
    bool isValid = false;
    int i = 0;
    for (i = 0; i < projectWithKey.length; i++) {
      isValid = projectWithKey[i].key.currentState?.validate(scrollOnValidate: true) ?? false;
      if (!isValid && scrollOnValidate) {
        expandSection();
        selectedIndex = i;
        update();
        return isValid;
        
      }
      if(!isValid){
        break;
      }
      
    }

    return isValid;
  }

  List<Map<String, dynamic>> fetchProjectData() {
    formData.clear();
    for (int i = 0; i < projectWithKey.length; i++) {
      formData.add(projectWithKey[i].key.currentState?.data() ?? {});
    }
    return formData;
  }

  Future<void> expandSection() async {
    // if section is already is expanded, no need to expand it again
    if (isSectionExpanded) return;

    isSectionExpanded = true;
    update();
    // additional delay for section to get expanded before focusing error field
    await Future<void>.delayed(const Duration(milliseconds: 300));

    validateForm(scrollOnValidate: true);
  }
}


