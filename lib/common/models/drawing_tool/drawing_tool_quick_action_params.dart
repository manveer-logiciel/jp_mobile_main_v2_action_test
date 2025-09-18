
import 'dart:ui';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolQuickActionParams {

  final int id;
  final Image? backgroundImage;
  final JPDrawingToolController drawingToolController;
  final FLModule? module;
  String? base64String;
  String? title;
  String? parentId;
  int? jobId;
  int rotationAngle;
  double? aspectRatio;
  double? width;
  double? height;

  DrawingToolQuickActionParams({
    required this.id,
    this.backgroundImage,
    required this.drawingToolController,
    this.module,
    this.base64String,
    this.title,
    this.parentId,
    this.jobId,
    this.rotationAngle = 0,
    this.aspectRatio,
    this.width,
    this.height,
  });



}