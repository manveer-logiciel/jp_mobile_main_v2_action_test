import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_quick_action_params.dart';
import 'package:jobprogress/common/services/drawing_tool/drawing_tool_repo.dart';
import 'package:jobprogress/common/services/drawing_tool/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'dart:ui' as ui;

class DrawingToolController extends GetxController
    with GetTickerProviderStateMixin {

  DrawingToolController();

  DrawingToolController.template({
    this.pageType = DrawingToolPageType.templateEditor
  });

  JPDrawingToolController drawingToolController = JPDrawingToolController(); // helps is controlling drawing elements

  ui.Image? backgroundImage; // used to display background image

  bool showBlueBackground = false;
  bool isStrokeActive = false; // used to show/hide stroke editor
  bool isSelectedDrawableIsText = false; // helps in differentiating text and other elements
  bool isInDrawableSelectionMode = false; // used to enable/disable drawable selection
  bool isToolBarVisible = true; // used to hide/show tool bar
  bool isEditorVisible = false; // used to hide/show editor
  bool isLoading = true; // used to manage loading state
  bool? isSaveAsActionPerformed;

  DrawingToolType selectedToolType = DrawingToolType.none; // helps in tools selection
  TextAlign selectedTextAlign = TextAlign.start; // used to set text alignment
  DrawingToolPageType? pageType;

  Map<ShapeFactory, String> shapes = {
    LineFactory(): 'line'.tr,
    OvalFactory(): 'circle'.tr,
    RectangleFactory(): 'rectangle'.tr,
    ArrowFactory(): 'arrow'.tr,
    DoubleArrowFactory(): 'double_arrow'.tr,
  }; // list of shapes to select from

  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round; // default drawable style

  final objectWidgetKey = GlobalKey<ObjectWidgetState>();

  FLModule? module = Get.arguments?['module'];
  String? imageId = Get.arguments?['id'];
  String? title = Get.arguments?['title'];
  int? jobId = Get.arguments?['jobId'];
  String? parentId = Get.arguments?[NavigationParams.parentId];
  String? localImagePath = Get.arguments?[NavigationParams.localImagePath];
  bool isPreviewImage = Get.arguments?['isPreviewImage'] ?? false;

  String? base64String;

  DrawingToolEditorType editorType = DrawingToolEditorType.addShape;

  @override
  void onInit() {
    pageType ??= DrawingToolPageType.imageEditor;
    isSaveAsActionPerformed = false;
    setUpDrawingController();
    // additional delay to avoid lags
    Future.delayed(const Duration(milliseconds: 200), () =>
        selectUnselectTool(DrawingToolType.pencil));
    super.onInit();
  }

  // setUpBgImage() : will load image from network
  void setUpBgImage() async {

    try {
      await loadBase64Image();

      ui.Image image;

      if (localImagePath != null) {
        image = await FileImage(File(localImagePath!)).image;
        base64String = base64Encode((await image.pngBytes)!);
      } else {
        if(base64String == null) return;
        image = await MemoryImage(base64Decode(base64String!)).image;
      }

      backgroundImage = image;

      // creating a canvas background
      drawingToolController.background = image.backgroundDrawable;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  // setUpDrawingController() : will initialize drawing controller
  void setUpDrawingController() {
    drawingToolController = JPDrawingToolController(
      settings: JPDrawingToolController.defaultPainterSettings(shapePaint),
    );
    // setting up bg image for canvas
    if (pageType == DrawingToolPageType.imageEditor) {
      setUpBgImage();
    }
    setOrientation();
  }

  void setOrientation() {
    if(Get.context!.orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    
    } else {
        SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]); 
    }
  }

  void resetOrientation() {
    if(!JPScreen.isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  // selectUnselectTool() : helps in selecting and unselecting drawing tool
  void selectUnselectTool(DrawingToolType drawingToolType) {

    isInDrawableSelectionMode = false;

    if(selectedToolType == drawingToolType) return;

    isSelectedDrawableIsText = false;
    drawingToolController.freeStyleStrokeWidth = getFreeStyleStroke();

    switch (drawingToolType) {
      case DrawingToolType.none:
        toggleStrokeSelection();
        break;
      case DrawingToolType.eraser:
        toggleEraser();
        break;
      case DrawingToolType.pencil:
        toggleBrush();
        break;
      case DrawingToolType.text:
        toggleText();
        break;
      case DrawingToolType.shape:
        toggleShapes();
        break;
    }

    selectedToolType = selectedToolType == drawingToolType
        ? DrawingToolType.none
        : drawingToolType;

    isStrokeActive = selectedToolType == DrawingToolType.eraser;

    editorType = getEditorType();

    update();
  }

  // toggleEraser() : will toggle eraser selection
  void toggleEraser() {
    isSelectedDrawableIsText = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.freeStyleMode =
        drawingToolController.freeStyleMode != FreeStyleMode.erase
            ? FreeStyleMode.erase
            : FreeStyleMode.none;
  }

  // toggleBrush() : will toggle brush selection
  void toggleBrush() {
    isSelectedDrawableIsText = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.freeStyleMode =
        drawingToolController.freeStyleMode != FreeStyleMode.draw
            ? FreeStyleMode.draw
            : FreeStyleMode.none;
  }


  bool isTextBold()  => drawingToolController.textSettings.textStyle.fontWeight == FontWeight.bold;
  
  bool isTextItalic()  => drawingToolController.textSettings.textStyle.fontStyle == FontStyle.italic;

  bool isTextUnderlined()  => drawingToolController.textSettings.textStyle.decoration == TextDecoration.underline;
  
  // addText() : will open up text dialog to add text
  void addText() {
    // unselecting other tools
    drawingToolController.freeStyleMode = FreeStyleMode.text;
    isStrokeActive = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
        textStyle: drawingToolController.textSettings.textStyle.copyWith(
          fontSize: drawingToolController.textSettings.textStyle.fontSize!,
          color: drawingToolController.freeStyleColor,
          fontStyle: drawingToolController.textSettings.textStyle.fontStyle,
          fontWeight: drawingToolController.textSettings.textStyle.fontWeight,
          decoration: drawingToolController.textSettings.textStyle.decoration,
        ),
    );
    drawingToolController.addText(); // will display text dialog and add text
  }

  // selectShape() : helps is selecting shape from [shapes] map
  void selectShape(ShapeFactory? factory) {
    showBlueBackground = false;
    drawingToolController.shapeFactory = factory;
    update();
  }

  // toggleText() : helps is toggling text selector
  void toggleText() {
    isSelectedDrawableIsText = true;
    drawingToolController.freeStyleMode = FreeStyleMode.text;
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
        fontSize: 10,
      ),
    );
    if (drawingToolController.shapeFactory != null) {
      drawingToolController.shapeFactory = null;
      isStrokeActive = false; // closing stroke editor
    }
  }

  // toggleShapes() : helps is toggling shapes selector
  void toggleShapes() {
    isSelectedDrawableIsText = false;
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    drawingToolController.shapePaint?.strokeWidth = 5;
    if (drawingToolController.shapeFactory != null) {
      drawingToolController.shapeFactory = null;
      isStrokeActive = false; // closing stroke editor
    }
  }

  // removeSelectedDrawable() : will delete/remove selected drawable
  void removeSelectedDrawable() {
    final selectedDrawable = drawingToolController.selectedObjectDrawable;
    if (selectedDrawable != null) {
      drawingToolController.removeDrawable(selectedDrawable);
    }
    isStrokeActive = false; // closing editor after removing item
    isSelectedDrawableIsText = false; // managing state for text editor
    update();
    selectLastAddedObjectDrawable();
  }

  // redo() : will redo is any other displays a message
  void redo() {
    if (!drawingToolController.canRedo) {
      Helper.showToastMessage('nothing_to_redo'.tr);
      return;
    }
    drawingToolController.redo();
    update();
  }

  void undo() {
    if (!drawingToolController.canUndo) {
      Helper.showToastMessage('nothing_to_undo'.tr);
      return;
    }
    drawingToolController.undo();
    update();
  }

  // toggleDrawableSelectionMode() : will help is enabling/disabling user interaction with drawables
  void toggleDrawableSelectionMode({bool selectLastDrawable = true}) {

    if(isInDrawableSelectionMode) return;

    isInDrawableSelectionMode = true;
    isStrokeActive = false;
      // unselecting all tools
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    drawingToolController.shapeFactory = null;
    selectedToolType = DrawingToolType.none;
    if(selectLastDrawable) selectLastAddedObjectDrawable();

    update();
  }

  Future<void> onTapEditText() async {
    objectWidgetKey.currentState?.tapDrawable(drawingToolController.selectedObjectDrawable!, openEditor: true);
  }

  void selectLastAddedObjectDrawable() {

    try {
      if (drawingToolController.drawables.isNotEmpty) {
        final drawable = drawingToolController.drawables.reversed.firstWhere((
            element) => element is ObjectDrawable);

        isSelectedDrawableIsText = drawable is TextDrawable;

            drawingToolController.selectObjectDrawable(drawable as ObjectDrawable);
        editorType = getEditorType(drawable: drawable);
        setSelectedItemStyle(drawable, false);
      } else {
        isEditorVisible = false;
      }
    } catch (e) {
      drawingToolController.selectObjectDrawable(null);
      editorType = getEditorType();
    }
  }

  // toggleStrokeSelection() : used to show/hide stroke editor
  void toggleStrokeSelection() {
    isStrokeActive = !isStrokeActive;
    editorType = getEditorType(drawable: isInDrawableSelectionMode
        ? drawingToolController.selectedObjectDrawable
        : null);
    update();
  }

  // showColorPicker() : will display color picker to choose color from
  void showColorPicker() async {

    showJPBottomSheet(
      child: (_) {
        return JPColorPicker(
          initialColor: drawingToolController.freeStyleColor,
          onColorApplied: (color) {
            setDrawableColor(color ?? Colors.black);
          },
          title: 'pick_color'.tr,
          prefixButtonText: 'reset'.tr,
          suffixButtonText: 'apply'.tr,
        );
      },
      isScrollControlled: true,
    );
    update();
  }

  // updateDrawnDrawable() : helps in editing already drawn drawables
  void updateDrawnDrawable() {
    // getting properties of currently selected drawable
    final selectedDrawable = drawingToolController.selectedObjectDrawable;

    if (selectedDrawable == null) return;

    ObjectDrawable newDrawable;

    // in case it is text updating accordingly
    if (isSelectedDrawableIsText) {
      newDrawable = TextDrawable(
          text: (selectedDrawable.textPainter!.text as TextSpan).text.toString(),
          style: TextStyle(
              color: drawingToolController.freeStyleColor,
              fontSize: drawingToolController.textSettings.textStyle.fontSize,
              fontWeight: drawingToolController.textSettings.textStyle.fontWeight,
              fontStyle: drawingToolController.textSettings.textStyle.fontStyle,
              decoration: drawingToolController.textSettings.textStyle.decoration,
          ),
          position: selectedDrawable.position,
          scale: selectedDrawable.scale,
          rotation: selectedDrawable.rotationAngle,
          textAlign: selectedTextAlign);
    } else {
      // in case it is shape update accordingly
      newDrawable = selectedDrawable.copyWith(
        paint: Paint()
          ..color = drawingToolController.freeStyleColor
          ..strokeWidth = drawingToolController.freeStyleStrokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        rotation: selectedDrawable.rotationAngle
      );
    }

    drawingToolController.replaceDrawable(selectedDrawable, newDrawable, newAction: false);
  }

  // setDrawableStrokeWidth() : is used to set stroke width of drawable
  void setDrawableStrokeWidth(double value) {
    drawingToolController.shapePaint = shapePaint.copyWith(
        strokeWidth: value > 20 ? 2 : value,
        color: drawingToolController.freeStyleColor);

    drawingToolController.freeStyleStrokeWidth = value > 20 ? 2 : value;

    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(fontSize: value));

    if (isInDrawableSelectionMode) {
      updateDrawnDrawable();
    }
    update();
  }

  // setDrawableColor() : will set drawable color
  void setDrawableColor(Color color) {
    drawingToolController.shapePaint = shapePaint.copyWith(color: color, strokeWidth: getStrokeWidth());

    drawingToolController.freeStyleColor = color;

    if (isInDrawableSelectionMode) {
      updateDrawnDrawable();
    }

    update();
  }

  // setDrawableColor() : set editor as per selected item (eg. color, stroke etc.)
  Future<void> setSelectedItemStyle(Drawable? drawable, bool isEditingText) async {

    if(drawable == null) {
      isSelectedDrawableIsText = false;
      toggleIsToolBarVisible(!isToolBarVisible);
    } else {
      toggleIsToolBarVisible(true);
    }

    editorType = getEditorType(drawable : drawable);

    await Future<void>.delayed(const Duration(milliseconds: 200));

    // getting selected item
    final selectedDrawable = drawingToolController.selectedObjectDrawable;

    // on unselecting drawables resetting editor
    if (selectedDrawable == null) {
      // isStrokeActive = selectedToolType == DrawingToolType.eraser;  
      drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
        textStyle: drawingToolController.textSettings.textStyle.copyWith(
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          decoration: TextDecoration.none
        ));

      if(isInDrawableSelectionMode) {
        isStrokeActive = selectedToolType == DrawingToolType.eraser;
      }
    } else {
      isStrokeActive = isInDrawableSelectionMode ? isStrokeActive : true; // displaying stroke editor
      isSelectedDrawableIsText = selectedDrawable is TextDrawable;

      if (isSelectedDrawableIsText) {
        selectedTextAlign = selectedDrawable.textPainter!.textAlign;

        TextPainter textPainter = (selectedDrawable as TextDrawable).textPainter;

        drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
            textStyle: drawingToolController.textSettings.textStyle.copyWith(
              fontSize: (textPainter.text!.style!.fontSize ?? 20),
              color: textPainter.text!.style!.color!,
              fontStyle: textPainter.text!.style!.fontStyle ?? (selectedDrawable).style.fontStyle ?? FontStyle.normal,
              fontWeight: textPainter.text!.style!.fontWeight ?? (selectedDrawable).style.fontWeight ?? FontWeight.normal,
              decoration: textPainter.text!.style!.decoration ?? (selectedDrawable).style.decoration ?? TextDecoration.none,
            ),
        );

      } else {
        Paint paint = selectedDrawable.objectPaint ?? Paint();
        setDrawableColor(paint.color);
        setDrawableStrokeWidth(paint.strokeWidth);
      }
    }

    update();
  }

  // getStrokeWidth(): will return font size/stroke width
  double getStrokeWidth() {
    if (drawingToolController.shapeFactory != null) {
      return drawingToolController.shapePaint?.strokeWidth ?? 1;
    } else if (isSelectedDrawableIsText || selectedToolType == DrawingToolType.text) {
      return (drawingToolController.textStyle.fontSize ?? 1);
    } else {
      return drawingToolController.freeStyleStrokeWidth > 20
          ? 2
          : drawingToolController.freeStyleStrokeWidth;
    }
  }

  // updateSelectedTextAlign() : will set selected text alignment
  void updateSelectedTextAlign(TextAlign textAlign) {
    selectedTextAlign = textAlign;
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextFontWeight() : will toggle between normal and bold font weight
  void toggleSelectedTextFontWeight() {
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
        fontWeight: drawingToolController.textSettings.textStyle.fontWeight == FontWeight.bold ? 
          FontWeight.normal: 
          FontWeight.bold
    ));
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextFontStyle() : will toggle between normal and italic font style
  void toggleSelectedTextFontStyle() {
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
        fontStyle: drawingToolController.textSettings.textStyle.fontStyle == FontStyle.italic ? 
          FontStyle.normal: 
          FontStyle.italic
    ));
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextDecoration() : will toggle between none and underline decoration
  void toggleSelectedTextDecoration() {
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
        decoration: drawingToolController.textSettings.textStyle.decoration == TextDecoration.underline ? 
          TextDecoration.none: 
          TextDecoration.underline
    ));
    updateDrawnDrawable();
    update();
  }

  // selectAddedTextDrawable() : will auto select text on adding one
  Future<void> selectAddedTextDrawable(TextDrawable? drawable) async {

    if(drawable == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 200));

    drawingToolController.selectObjectDrawable(drawable);

    toggleDrawableSelectionMode();

    setSelectedItemStyle(drawable, false);

    editorType = getEditorType(drawable: drawable);
  }

  void toggleIsToolBarVisible(bool val) {

    if(!isInDrawableSelectionMode && selectedToolType != DrawingToolType.none) return;

    isToolBarVisible = val;
    update();
  }

  void rotateCanvas() {
   drawingToolController.rotateCanvas(
     Size(backgroundImage!.width + 0.0, backgroundImage!.height + 0.0)
   );
  }

  void showSaveOptions(String type, {bool isPreviewImage = false}) {

    if(type == 'save_as') isSaveAsActionPerformed = true;
    DrawingToolService.optionToAction(
      value: type,
      isPreviewImage: isPreviewImage,
      isSaveAsActionPerformed: isSaveAsActionPerformed,
      actionParams: DrawingToolQuickActionParams(
        id: int.tryParse(imageId.toString()) ?? -1,
        backgroundImage: backgroundImage,
        module: module,
        title: title,
        parentId: parentId,
        jobId: jobId,
        drawingToolController: drawingToolController,
        rotationAngle: -drawingToolController.quarterTurns * 90
      )
    );
    if(type == 'save') {
      resetOrientation();
    }
  }

  // updateForFirstDrawable() : is used to update state of undo/redo button when first drawable is drawn
  void updateForFirstDrawable() {
    if(drawingToolController.drawables.length == 1) {
      update();
    }
  }

  DrawingToolEditorType getEditorType({Drawable? drawable}) {

    isEditorVisible = chkIsEditorVisible(drawable: drawable);
    bool isShapeDrawable = chkIsShapeDrawable(drawable: drawable);

    if(selectedToolType == DrawingToolType.shape) {
      return DrawingToolEditorType.addShape;
    } else if(selectedToolType == DrawingToolType.pencil) {
      return DrawingToolEditorType.addBrush;
    } else if(isShapeDrawable) {
      return DrawingToolEditorType.editShape;
    } else if(drawable is TextDrawable || selectedToolType == DrawingToolType.text) {
      return DrawingToolEditorType.editText;
    } else {
      return editorType;
    }
  }

  bool chkIsEditorVisible({Drawable? drawable}) {
    return (drawable != null
        || selectedToolType == DrawingToolType.shape
        || selectedToolType == DrawingToolType.pencil
        || selectedToolType == DrawingToolType.text
        || isSelectedDrawableIsText)
        && selectedToolType != DrawingToolType.eraser
        && !isStrokeActive;
  }

  bool chkIsShapeDrawable({Drawable? drawable}) {
    return drawable is LineDrawable
        || drawable is RectangleDrawable
        || drawable is OvalDrawable
        || drawable is ArrowDrawable
        || drawable is DoubleArrowDrawable;
  }

  void showResetConfirmation() {
    showJPBottomSheet(
        child: (_) {
          return JPConfirmationDialog(
            icon: Icons.warning_amber_outlined,
            title: 'confirmation'.tr,
            subTitle: 'you_are_about_to_reset_all_your_changes'.tr,
            suffixBtnText: 'reset'.tr,
            onTapSuffix: () {

              for (var _ in drawingToolController.drawables) {
                undo();
              }

              drawingToolController.clearDrawables(newAction: false);

              isInDrawableSelectionMode = false;

              selectUnselectTool(DrawingToolType.pencil);

              update();
              Get.back();
            },
          );
        },
    );
  }

  Future<bool> onWillPop() async {
    if(drawingToolController.drawables.isNotEmpty || drawingToolController.canRedo) {
      showJPBottomSheet(
        child: (_) {
          return JPConfirmationDialog(
            icon: Icons.warning_amber_outlined,
            title: 'confirmation'.tr,
            subTitle: 'all_your_saved_changes_will_be_lost'.tr,
            suffixBtnText: 'confirm'.tr,
            onTapSuffix: () {
              Get.back();
              Get.back(
                result: {
                  'files' : DrawingToolService.fileList,
                  'action' : 'save_as'
                });
               resetOrientation();
            },
          );
        },
      );
    } else {
      if(isPreviewImage) {
        if(isSaveAsActionPerformed ?? false) {
          Get.back(
            result: {
              'files' : DrawingToolService.fileList,
              'action' : 'save_as',
              'save_as' : isSaveAsActionPerformed
            }
          );
        } else{
          Get.back();
        }
      } else {
        Get.back(result: {
          'save_as' : isSaveAsActionPerformed
        });
      }
      resetOrientation();
    }
    return false;
  }

  Future<void> loadBase64Image() async {
    try {
      if(module == null || imageId == null) return;

      String? response = await DrawingToolRepo.getBase64String(type: module!, id: int.parse(imageId!));

      base64String = response;

    } catch (e) {
      rethrow;
    }
  }

  double getFreeStyleStroke() {
    switch (pageType) {
      case DrawingToolPageType.imageEditor:
        return 5;

      case DrawingToolPageType.templateEditor:
        return 2;

      default:
        return 5;
    }
  }

}