/// this modal used for returing data with total count
/// from local DB
library;
import 'package:jobprogress/common/models/sql/user/user.dart';
class UserResponseModel {
  List<UserModel> data;
  int? totalCount;

  UserResponseModel({required this.data, this.totalCount});
}