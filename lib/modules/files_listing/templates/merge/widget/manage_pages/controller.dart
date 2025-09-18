import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';

class MergeTemplateManagePagesController extends GetxController {

  MergeTemplateManagePagesController(this.pages);

  final List<FormProposalTemplateModel> pages;
  List<FormProposalTemplateModel> tempPages = [];

  bool get canShowRemoveIcon => tempPages.length > 1;

  @override
  void onInit() {
    tempPages.addAll(pages);
    super.onInit();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = tempPages.removeAt(oldIndex);
    tempPages.insert(newIndex, item);
    update();
  }

  void removePage(int index) {
    tempPages.removeAt(index);
    update();
  }

}