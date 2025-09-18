import 'dart:io';

import 'package:jobprogress/common/models/sql/division/division_limited.dart';
import 'package:jobprogress/common/models/sql/tag/tag_limited.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/sql.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
class SqlUserRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<UserModel> users) async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < users.length; i++) {
      final user = users[i];

      user.companyId ??= companyId;

      batch.insert('user', user.toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Getting records from local DB
  Future<UserResponseModel> get({UserParamModel? params}) async {
    params = params ?? UserParamModel();

    if(!(Platform.isAndroid || Platform.isIOS)) {
      return UserResponseModel(data: []);
    }

    int companyId = await AuthService.getCompanyId();
    final dbClient = await DBProvider().db;

    String tagQuery = '';
    String divisionQuery = '';
    String userTypeQuery = ' AND user.group_id NOT IN (${UserGroupIdConstants.subContractor},${UserGroupIdConstants.subContractorPrime}) ';
    String usersWithAllDivisionsQuery = ' OR user_divisions.division_id IS NULL';

    bool includeTags = false;
    bool includeDivisions = false;

    int activeUsers = 1; // 1 for active and 0 for in active users

    if(params.onlySub) {
      userTypeQuery = ' AND user.group_id IN (${UserGroupIdConstants.subContractor},${UserGroupIdConstants.subContractorPrime}) ';
    } else if (params.withSubContractorPrime) {
      userTypeQuery = ' AND user.group_id <> ${UserGroupIdConstants.subContractor} ';
    }

    if (params.inactive) activeUsers = 0;

    /// adding query for including tags
    if (params.includes!.contains('tags')) {
      includeTags = true;
      tagQuery = SqlHelper.getGroupConcatQuery('tags', SqlConstants.tagKeys['all']);
    }
    /// adding query for including divisions
    if (params.includes!.contains('divisions')) {
      includeDivisions = true;
      divisionQuery = SqlHelper.getGroupConcatQuery('divisions', SqlConstants.divisionKeys['all']);
    }

    /// Getting total count of users
    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM user ${params.name.isNotEmpty ?
                'WHERE full_name LIKE "%${params.name}%" AND company_id = $companyId $userTypeQuery' :
                'WHERE company_id = $companyId $userTypeQuery'}'
    ));

    /// Ex.
    /// users = {
    ///   id:1,
    ///   name: 'abc',
    ///   ...
    ///   divisions: [{
    ///     division records
    ///   }]
    /// }
    /// Getting user records with divisions array
    String userWithDivisionsQuery = 'SELECT user.* ' +
        divisionQuery +
        'FROM user ' +
        (includeDivisions
            ? '''
          LEFT JOIN user_divisions
            ON user_divisions.user_id = user.id
          LEFT JOIN divisions
            ON divisions.id = user_divisions.division_id
        '''
            : '') +
        'WHERE full_name LIKE "%${params.name}%" AND user.company_id = $companyId $userTypeQuery' +
        (
            params.withInactive != true ?
            'AND user.active = $activeUsers ' :
            ''
        ) + (
        params.divisionIds!.isNotEmpty ?
        ''' AND user.id in (SELECT user.id FROM user
            LEFT JOIN user_divisions ON user_divisions.user_id = user.id
            WHERE user_divisions.division_id IN (${params.divisionIds!.join(',')}) $usersWithAllDivisionsQuery) 
          ''' : ''
    ) +
        '''
          GROUP BY user.id
          ORDER BY first_name ASC
        ''' +
        (params.limit != 0 ? ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' : '');

    /// Ex.
    /// users = {
    ///   id:1,
    ///   tags: [{
    ///     tag records
    ///   }]
    /// }
    /// Getting user records with tags array
    String userWithTagsQuery = 'SELECT user.id ' +
        tagQuery +
        'FROM user ' +
        (includeTags
            ? '''
          LEFT JOIN user_tags
            ON user_tags.user_id = user.id
          LEFT JOIN tags
            ON tags.id = user_tags.tag_id
        '''
            : '') +
        'WHERE full_name LIKE "%${params.name}%" AND user.company_id = $companyId $userTypeQuery' +
        (
            params.withInactive != true ?
            'AND user.active = $activeUsers ' :
            ''
        ) + (
        params.divisionIds!.isNotEmpty ?
        ''' AND user.id in (SELECT user.id FROM user
            LEFT JOIN user_divisions ON user_divisions.user_id = user.id
            WHERE user_divisions.division_id IN (${params.divisionIds!.join(',')})) 
          ''' : ''
    ) +
        '''
          GROUP BY user.id
          ORDER BY first_name ASC
        ''' +
        (params.limit != 0 ? ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' : '');

    List<dynamic> userWithDivisions = await dbClient.rawQuery(userWithDivisionsQuery);
    List<dynamic> userWithTags = await dbClient.rawQuery(userWithTagsQuery);

    final List<dynamic> userList = [];

    /// Adding tags array into user list that have division list
    if(userWithDivisions.length == userWithTags.length) {
      for (var i = 0; i < userWithDivisions.length; i++) {
        final newUser = {
          ...userWithDivisions[i],
          'tags': '[]'
        };

        if(
        userWithTags[i]['id'] == userWithDivisions[i]['id'] &&
            userWithTags[i]['tags'] != null
        ) {
          newUser['tags'] = userWithTags[i]['tags'];
        }

        userList.add(newUser);
      }
    } else {
      userList.addAll(userWithDivisions);
    }

    List<DivisionLimitedModel> allDivisions = (await dbClient.rawQuery('SELECT id, code, name FROM divisions WHERE company_id = $companyId'))
        .map((division) => DivisionLimitedModel.fromJson(division))
        .toList();

    List<UserModel> users = [];

    // if all divisions access to user then return all divisions with user
    for (var user in userList) {
      UserModel tempUser = UserModel.fromJson(user);

      if(tempUser.allDivisionsAccess ?? false) {
        tempUser.divisions = allDivisions;
      }

      users.add(tempUser);
    }

    UserResponseModel response = UserResponseModel(
      data: users,
      totalCount: count,
    );

    return response;
  }

  /// Clear table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'user',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

  /// Getting one record from local db
  Future<dynamic> getOne(int id) async {
    final dbClient = await DBProvider().db;

    List<UserModel> users = (await dbClient!.rawQuery('SELECT * FROM user where id = $id'))
      .map((user) => UserModel.fromJson(user))
      .toList();

    if (users.isNotEmpty) {
      List<TagLimitedModel> tags = (await dbClient.rawQuery('''
          SELECT tags.id, tags.name FROM user_tags
          LEFT JOIN tags ON tags.id = user_tags.tag_id
          WHERE user_tags.user_id = $id
        '''))
        .map((tag) => TagLimitedModel.fromJson(tag))
        .toList();

      /// if user has all division access then return all divisions
      /// if not then check division relations and return related records
      String divisionQuery = users[0].allDivisionsAccess == true ?
        'SELECT id,name,code FROM divisions' :
        '''
          SELECT divisions.id, divisions.name, divisions.code FROM user_divisions
          LEFT JOIN divisions ON divisions.id = user_divisions.division_id
          WHERE user_divisions.user_id = $id
        ''';

      List<DivisionLimitedModel> divisions = (await dbClient.rawQuery(divisionQuery))
        .map((tag) => DivisionLimitedModel.fromJson(tag))
        .toList();

      /// adding divisions & tags in user object
      users[0].tags = tags;
      users[0].divisions = divisions;

      return users[0];
    } else {
      return {};
    }
  }
}
