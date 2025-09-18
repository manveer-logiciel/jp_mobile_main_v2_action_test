import 'package:jobprogress/modules/files_listing/templates/handwritten/widgets/drawing_editor/controller.dart';
import 'package:jobprogress/modules/files_listing/templates/handwritten/widgets/template_editor/controller.dart';

/// [HandwrittenEditorModel] helps in managing controllers
/// for 2 separate editors and also helps in preparing server json
class HandwrittenEditorModel {

  // for accessing drawing controller
  HandwrittenDrawingController drawingController;
  // for accessing template page controller
  HandwrittenTemplateEditorController pageController;

  HandwrittenEditorModel(this.drawingController, this.pageController);

  Future<Map<String, dynamic>> toJson() async {
    final templateCover = await drawingController.getBase64String();
    final template = await pageController.getHtml();
    return {
      'template': template,
      'template_cover': templateCover
    };
  }

  Future<Map<String, dynamic>> toUnsavedResourceJson() async {
    final templateCover = await drawingController.getBase64String();
    final templateHtml = await pageController.getHtml();
    return {
      'template_html': templateHtml,
      'template_cover': templateCover
    };
  }
}