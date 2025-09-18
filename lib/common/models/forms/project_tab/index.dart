import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/modules/project/project_form/form/index.dart';

class ProjectTabModel {
  GlobalKey<ProjectFormState> key;
  List<InputFieldParams> fields;
  ProjectTabModel({required this.key, required this.fields});
}