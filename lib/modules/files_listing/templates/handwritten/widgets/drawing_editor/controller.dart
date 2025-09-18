import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_quick_action_params.dart';
import 'package:jobprogress/common/services/drawing_tool/index.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/constants/templates/size.dart';
import 'package:jobprogress/modules/drawing_tool/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HandwrittenDrawingController extends DrawingToolController {

  HandwrittenDrawingController({
    this.templateCover,
    this.pageSize
  }) : super.template();

  String? pageSize; // stores the size of the page
  String? templateCover; // used to display saved content over html template

  late Size editorSize; // helps in managing the editor page size
  late double aspectRatio; // helps in managing the frame size of editor

  @override
  void onInit() {
    setUpEditorDimensions();
    setUpBgImage();
    setOrientation();
    super.onInit();
  }

  void setUpEditorDimensions() {
    bool isA4Page = pageSize == TemplateConstants.a4page;
    editorSize = isA4Page ? TemplateFormSize.a4 : TemplateFormSize.legal;
    aspectRatio = isA4Page ? TemplateFormSize.a4AspectRatio : TemplateFormSize.legalAspectRatio;
  }

  @override
  void setUpBgImage() async {
    if (templateCover == null) return;

    try {
      templateCover = DrawingToolService.removeExtrasFromBase64String(templateCover!);
      ui.Image image = await MemoryImage(base64Decode(templateCover!)).image;

      backgroundImage = image;
      // creating a canvas background
      drawingToolController.addDrawables([image.backgroundDrawable], newAction: false);
      drawingToolController.performedActions.clear();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void updateForFirstDrawable() {
    int count = templateCover == null ? 1 : 2;
    if (drawingToolController.drawables.length == count) {
      update();
    }
  }

  /// [getBase64String] returns the base64 string of added drawables
  Future<String> getBase64String() async {
    final actionParams = DrawingToolQuickActionParams(
      id: -1,
      width: editorSize.width,
      height: editorSize.height,
      drawingToolController: drawingToolController,
    );

    final base64String = await DrawingToolService.getBase64String(actionParams, asPng: true);

    return base64String ?? "";
  }

  /// [isAnyChangeMade] helps in checking whether any changes in drawing are made or not
  bool isAnyChangeMade() {
    return drawingToolController.canUndo || drawingToolController.canRedo;
  }

  /// [clearAllActions] helps in clearing actions on saving form
  void clearAllActions() {
    drawingToolController.performedActions.clear();
  }

  /// [resetZoom] helps in bringing content to it's initial scale
  void resetZoom() {
    drawingToolController.transformationController.value = Matrix4.identity();
  }

  /// [mapController] helps in mapping data of one controller to other
  void mapController(DrawingToolController data) {

    final dataController = data.drawingToolController;

    showBlueBackground = data.showBlueBackground;
    isStrokeActive = data.isStrokeActive;
    isSelectedDrawableIsText = data.isSelectedDrawableIsText;
    isInDrawableSelectionMode = data.isInDrawableSelectionMode;
    isToolBarVisible = data.isToolBarVisible;
    isEditorVisible = data.isEditorVisible;
    isLoading = data.isLoading;

    selectedTextAlign = data.selectedTextAlign;
    if (selectedToolType != data.selectedToolType) {
      selectUnselectTool(data.selectedToolType);
    }
    drawingToolController.freeStyleStrokeWidth = dataController.freeStyleStrokeWidth;
    selectShape(dataController.shapeFactory);
    drawingToolController.textSettings = dataController.textSettings.copyWith();
    drawingToolController.shapeSettings = dataController.shapeSettings.copyWith();
    drawingToolController.freeStyleSettings = dataController.freeStyleSettings.copyWith();

    if (selectedToolType == DrawingToolType.none) {
      drawingToolController.selectObjectDrawable(null);
      isStrokeActive = false;
      isEditorVisible = false;
      isInDrawableSelectionMode = false;
      toggleDrawableSelectionMode(selectLastDrawable: false);
    }
  }

}