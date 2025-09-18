
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';

class FirestoreLocalDBHelper {

  static Future<Map<String, UserLimitedModel>?> getAllUsers() async {

    if(GroupsData.allUsers.isNotEmpty) return null;

    final loggedInUserId = AuthService.userDetails?.id;

    Map<String, UserLimitedModel> usersMap = {};

    UserParamModel params = UserParamModel(
        limit: -1,
        withSubContractorPrime: true
    );

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);

    for (UserModel user in allUsers.data) {
      usersMap.putIfAbsent(user.id.toString(), () => UserLimitedModel.fromJson(user.toJson()));
    }

    usersMap.remove(loggedInUserId.toString());

    return usersMap;
  }

}