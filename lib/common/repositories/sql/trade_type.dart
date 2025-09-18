import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/sql.dart';
import 'package:jobprogress/core/utils/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

class SqlTradeTypeRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<TradeTypeModel>? trades) async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    
    for (var i = 0; i < trades!.length; i++) {
      TradeTypeModel trade = TradeTypeModel(
        id: trades[i].id,
        color: trades[i].color,
        name: trades[i].name,
        active: trades[i].active,
        companyId: companyId
      );

      batch.insert('trade_type', trade.toJson());
    }

    return await batch.commit(continueOnError:true);
  }
  /// Clear table data
  Future<int> clearRecords() async {
    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'trade_type',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }
  /// Getting records from local DB
  Future<TradeTypeResponseModel> get({TradeTypeParamModel? params}) async {
    params = params ?? TradeTypeParamModel();

    final dbClient = await DBProvider().db;
    int companyId = AuthService.userDetails!.companyDetails!.id;

    String workTypeQuery = '';
    int activeUsers = 1; // 0 for active and 1 for in active users

    bool includeWorkType = false;

    if (params.inactive) activeUsers = 0;
    /// adding query for related work type
    if (params.includes!.contains('work_type')) {
      includeWorkType = true;
      workTypeQuery = SqlHelper.getGroupConcatQuery('work_type', SqlConstants.workTypeKeys['all']);
    }
    /// Getting total count
    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM trade_type ${params.name.isNotEmpty ?
        'WHERE name LIKE "%${params.name}%" AND company_id = $companyId ' :
        'WHERE company_id = $companyId'}'
    ));
    
    /// Ex. 
    /// tradetype = {
    ///   id:1,
    ///   name: 'abc',
    ///   ...
    ///   work_type: [{
    ///     work_type records
    ///   }]
    /// }
    /// Getting user records with work_type array
    String query = 'SELECT trade_type.* ' +
      workTypeQuery +
      ' FROM trade_type '+
      (includeWorkType
          ? '''          LEFT JOIN work_type
          ON work_type.trade_id = trade_type.id
        ${params.withInActiveWorkType ? '' : 'AND work_type.active = 1'}'''
          : '') +
      ' WHERE trade_type.name LIKE "%${params.name}%"  AND trade_type.company_id = $companyId ' +
        (
          params.withInactive != true ?
            'AND active = $activeUsers ' :
            ''
        ) +
      '''
        GROUP BY trade_type.id
        ORDER BY name ASC
      ''' +
      (params.limit != 0 ? ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' : '');

    List<TradeTypeModel> tradeTypes =
        (await dbClient.rawQuery(query)).map((referral) => TradeTypeModel.fromJson(referral))
            .toList();

    TradeTypeResponseModel response = TradeTypeResponseModel(
      data: tradeTypes,
      totalCount: count,
    );

    return response;
  }
}
