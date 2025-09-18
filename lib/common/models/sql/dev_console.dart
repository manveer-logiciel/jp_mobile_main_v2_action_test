import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/dev_console/index.dart';
import 'package:jobprogress/common/services/mixpanel/view_observer.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/common/libraries/global.dart' as global;

class DevConsoleModel {
  int? id;
  String? type;
  String? description;
  String? page;
  String? appVersion;
  int? companyId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  DevConsoleModel({
    this.id,
    this.type,
    this.description,
    this.page,
    this.companyId,
    this.userId,
    this.appVersion,
    this.createdAt,
    this.updatedAt,
  });

  DevConsoleModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? -1;
    type = (json['type'] ?? "").toString();
    description = (json['description'] ?? "").toString();
    page = (json['page'] ?? "").toString().replaceAll(RegExp(RegexExpression.removeSpecialCharacters), " ").trim().capitalize;
    companyId = int.tryParse(json['company_id'].toString()) ?? -1;
    userId = int.tryParse(json['user_id'].toString()) ?? -1;
    appVersion = (json['app_version'] ?? global.appVersion).toString();
    final tempCreatedAt = DateTime.tryParse(json['created_at'].toString())?.toString() ?? "${DateTime.now()}";
    createdAt = Jiffy.parse(tempCreatedAt).format(pattern: DateFormatConstants.dateTimeFormatWithoutSeconds);
    updatedAt = (json['updated_at'] ?? "").toString();
  }

  DevConsoleModel.fromError(Object? e) {
    type = DevConsoleService.getErrorType(e);
    description = DevConsoleService.getErrorDescription(e);
    page = Helper.isValueNullOrEmpty(MixPanelViewObserver.currentPathName)
        ? Get.currentRoute
        : MixPanelViewObserver.currentPathName;
    companyId = AuthService.userDetails?.companyDetails?.id ?? -1;
    userId = AuthService.userDetails?.id ?? -1;
    appVersion = global.appVersion;
    createdAt = DateTime.now().toString();
    updatedAt = DateTime.now().toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['description'] = description;
    data['page'] = page;
    data['company_id'] = companyId;
    data['user_id'] = userId;
    data['app_version'] = appVersion;
    data['created_at'] = (createdAt ?? DateTime.now()).toString();
    data['updated_at'] = (updatedAt ?? DateTime.now()).toString();
    return data;
  }
}