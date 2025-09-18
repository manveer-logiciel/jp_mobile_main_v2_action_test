import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_param.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_response.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlReferralSourcesRepository {

  /// Bulk insert referrals
  Future<List<Object?>> bulkInsert(List<ReferralSourcesModel>? referrals) async {
    int companyId = await AuthService.getCompanyId();
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < referrals!.length; i++) {

      final referral = referrals[i]
        ..companyId = companyId;

      batch.insert('referral_sources', referral.toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Clear referrals table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();
    
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'referral_sources',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

  /// Getting records from local DB
  Future<ReferralSourceResponseModel> get({ReferralSourceParamModel? params}) async {
    params = params ?? ReferralSourceParamModel();

    final dbClient = await DBProvider().db;

    int companyId = await AuthService.getCompanyId();
    int activeUsers = 1; // 0 for active and 1 for in active users
    
    if (params.inactive) activeUsers = 0;

    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM referral_sources ${params.name.isNotEmpty ?
        'WHERE name LIKE "%${params.name}%" AND company_id = $companyId ' :
        'WHERE company_id = $companyId'}'
    ));

    String query = 'SELECT * FROM referral_sources WHERE name LIKE "%${params.name}%" AND company_id = $companyId ${params.withInactive != true ?
          'AND active = $activeUsers ' :
          ''}${params.limit != 0 ?
          ' LIMIT ${params.limit} OFFSET ${params.page * params.limit} ' :
          ''}';

    List<ReferralSourcesModel> referrals = (await dbClient.rawQuery(query))
      .map((referral) => ReferralSourcesModel.fromJson(referral))
      .toList();

    ReferralSourceResponseModel response = ReferralSourceResponseModel(
      data: referrals,
      totalCount: count,
    );

    return response;
  }
}
