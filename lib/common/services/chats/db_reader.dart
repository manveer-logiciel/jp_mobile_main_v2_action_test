
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/tag/tag_response.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';

import '../../../core/constants/user_roles.dart';

/// ChatsDbReader reads local db and parse them accordingly
class ChatsDbReader {

  // getAllUsers(): load users from local db and parse it to JPMultiSelectModel to make them a
  //                selectable list
  static Future<List<JPMultiSelectModel>> getAllUsers({
    bool onlySub = false,
    bool withSubContractorPrime = true
  }) async {
    List<JPMultiSelectModel> users = []; // initializing list

      UserParamModel params = UserParamModel(
        includes: ['tags', 'divisions'],
        limit: -1,
        onlySub: onlySub,
        withSubContractorPrime: withSubContractorPrime
      );

    await SqlUserRepository().get(params: params).then((userData) {
      
      List<TagLimitedModel> tag = [];

      for (var user in userData.data) {
        if(user.tags != null){
          for(var tags in user.tags!) {
            tag.add(TagLimitedModel(id:tags.id ,name: tags.name));
          }
        }
        users.add(JPMultiSelectModel(
          id: user.id.toString(),
          label:  user.groupId == UserGroupIdConstants.subContractorPrime ?  
            '${user.fullName} (${'sub'.tr})' :  
            user.fullName,
          tags: tag,
          isSelect: false,child:JPProfileImage(
            src: user.profilePic,
            color: user.color,
            initial: user.intial,
          ),
        ));

        tag = [];
      }
    });

    return users;
  
  }

  static Future<List<JPMultiSelectModel>> getAllTags() async {

    TagParamModel params = TagParamModel(
      includes: [
        'users'
      ]
    );

    TagResponseModel allTags = await SqlTagsRepository().get(params: params);
    List<JPMultiSelectModel> tags = []; // initializing list

    for(TagModel tag in allTags.data) {

      if(tag.users == null) continue;

      tags.add(JPMultiSelectModel(
        label: "${tag.name} (${tag.users?.length ?? 0})",
        id: tag.id.toString(),
        isSelect: false,
        additionData: tag
      ));
    }

    return tags;
  }

}