import 'dart:io';

import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/tag/tag_response.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/sql.dart';
import 'package:jobprogress/core/utils/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

class SqlTagsRepository {

  /// Bulk insert tags
  Future<List<Object?>> bulkInsert(List<TagModel> tags) async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < tags.length; i++) {

      final tag = tags[i]
        ..companyId = companyId;

      batch.insert('tags', tag.toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Clear table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();
    
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'tags',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

  /// Getting records from local DB
  Future<TagResponseModel> get({TagParamModel? params}) async {
    params = params ?? TagParamModel();

    if(!(Platform.isAndroid || Platform.isIOS)) {
      return TagResponseModel(data: []);
    }


    final dbClient = await DBProvider().db;

    int companyId = await AuthService.getCompanyId();

    bool includeUser = false;
    String userQuery = '';

    int activeUsers = 1; // 0 for active and 1 for in active users
    
    if (params.inactive) activeUsers = 0;

    /// adding related users in tags records
    if (params.includes!.contains('users')) {
      includeUser = true;
      userQuery = SqlHelper.getGroupConcatQuery('user', SqlConstants.userKeys['all']);
    }

    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM tags ${params.name.isNotEmpty ?
        'WHERE name LIKE "%${params.name}%" AND company_id = $companyId ' :
        'WHERE company_id = $companyId'}'
    ));

    /// Ex. 
    /// tags = {
    ///   id:1,
    ///   name: 'abc',
    ///   ...
    ///   users: [{
    ///     users records
    ///   }]
    /// }
    /// Getting user records with users array
    String query = 'SELECT tags.* ' +
        userQuery +
        'FROM tags ' +
        (includeUser
          ? '''
          LEFT JOIN user_tags
            ON user_tags.tag_id = tags.id
          LEFT JOIN user
            ON user_tags.user_id = user.id
        '''
          : '') +
        'WHERE name LIKE "%${params.name}%" AND tags.company_id = $companyId ' +
        (
          params.withInactive != true ? 
            'AND tags.active = $activeUsers ' :
            ''
        ) +
        '''
          GROUP BY tags.id
          ORDER BY name ASC
        ''' +
        (params.limit != 0 ? ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' : '');

    List<TagModel> tempTagsArray = (await dbClient.rawQuery(query))
      .map((tag) => TagModel.fromJson(tag))
      .toList();

    TagResponseModel response = TagResponseModel(
      data: tempTagsArray,
      totalCount: count,
    );

    return response;
  }
}
