import 'package:flutter/cupertino.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [ConsentLabelDetailsModel] contains the details of a consent label
class ConsentLabelDetailsModel {
  String label;
  String toolTip;
  Color color;
  String composeLabel;
  String composeMessage;
  String composeMessageButtonText;
  Color composeMessageButtonTextColor;
  JPButtonColorType composeMessageButtonColor;
  IconData icon;

  ConsentLabelDetailsModel({
    required this.label,
    required this.toolTip,
    required this.composeLabel,
    required this.composeMessage,
    required this.color,
    required this.icon,
    this.composeMessageButtonText = 'edit_consent',
    this.composeMessageButtonColor = JPButtonColorType.lightGray,
    this.composeMessageButtonTextColor = JPColor.tertiary,
  });
}