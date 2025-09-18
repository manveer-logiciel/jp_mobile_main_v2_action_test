import 'params.dart';

/// [FormSectionModel] contains data about the section
/// to displayed in form
class FormSectionModel {

  /// [name] holds the name of the section
  String name;

  /// [wrapInExpansion] helps in deciding whether to wrap section in expansion tile or not
  bool wrapInExpansion;

  /// [isExpanded] will be in action when [wrapInExpansion] is true
  /// it helps in maintaining the state of section expansion
  bool isExpanded;

  /// [initialCollapsed] will be in action when [wrapInExpansion] is true
  /// it helps in deciding whether section will be initially expanded or not
  bool initialCollapsed;

  /// [fields] contains list of fields that belongs to section
  List<InputFieldParams> fields;

  /// [avoidContentPadding] helps in avoiding content padding of expansion tile
  bool avoidContentPadding;

  FormSectionModel({
    required this.name,
    required this.fields,
    this.wrapInExpansion = true,
    this.isExpanded = false,
    this.initialCollapsed = true,
    this.avoidContentPadding = false,
  });
}