import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_limited.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/models/sql/division/division_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/sql.dart';
import 'package:jobprogress/core/utils/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
class SqlDivisionRepository {

  /// Bulk insert Division data into divisions table
  Future<List<Object?>> bulkInsert(List<DivisionModel> divisions) async{
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < divisions.length; i++) {
      batch.insert('divisions', divisions[i].toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Clear divisions table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'divisions',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

  /// Getting division records from local DB
  Future<DivisionResponseModel> get({DivisionParamModel? params}) async {
    params = params ?? DivisionParamModel();

    /// Get divisions according to user divisions
    UserModel loggedInUser = AuthService.userDetails!;

    List<int> divisionIds = [];

    for (DivisionLimitedModel division in loggedInUser.divisions!) {
      divisionIds.add(division.id);
    }

    final dbClient = await DBProvider().db;

    int companyId = loggedInUser.companyDetails!.id;

    bool includeUser = false;
    String userQuery = '';

    int activeUsers = 1; // 0 for active and 1 in active users
    
    if (params.inactive) activeUsers = 0;

    if (params.includes!.contains('users')) {
      includeUser = true;
      userQuery = SqlHelper.getGroupConcatQuery('user', SqlConstants.userKeys['all']);
    }
    
    // Getting total count of divisions
    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM divisions ${params.name.isNotEmpty ?
        'WHERE name LIKE "%${params.name}%" AND company_id = $companyId ' :
        'WHERE company_id = $companyId '}${divisionIds.isNotEmpty ? 'AND divisions.id IN (${divisionIds.join(',')}) ' : ''}'
    ));

    /// Ex. 
    /// divisions = {
    ///   id:1,
    ///   name: 'abc',
    ///   ...
    ///   users: [{
    ///     users records
    ///   }]
    /// }
    /// Getting user records with users array
    String query = 'SELECT divisions.* ' +
        userQuery +
        'FROM divisions ' +
        (includeUser
          ? '''
          LEFT JOIN user_divisions
            ON user_divisions.division_id = divisions.id
          LEFT JOIN user
            ON user.id = user_divisions.user_id
        '''
          : '') +
        'WHERE name LIKE "%${params.name}%" AND divisions.company_id = $companyId ' +
        (
          divisionIds.isNotEmpty ? 'AND divisions.id IN (${divisionIds.join(',')}) ' : ''
        ) + (
          params.withInactive != true ? 
            'AND divisions.active = $activeUsers ' :
            ''
        ) +
        '''
          GROUP BY divisions.id
          ORDER BY name ASC
        ''' +
        (params.limit != 0 ? ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' : '');

    List<DivisionModel> tempDivisionArray = (await dbClient.rawQuery(query))
      .map((division) => DivisionModel.fromJson(division))
      .toList();

    DivisionResponseModel response = DivisionResponseModel(
      data: tempDivisionArray,
      totalCount: count,
    );

    return response;
  }
}
