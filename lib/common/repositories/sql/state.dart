import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlStateRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<StateModel> state) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < state.length; i++) {
      batch.insert('state', state[i].toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Getting records from local DB
  Future<List<StateModel?>> get({int? countryId, bool applyCompanyFilter = true}) async {

    final companyId = AuthService.userDetails!.companyDetails?.id;

    final dbClient = await DBProvider().db;

    String query = 'SELECT state.* FROM state ';

    if(applyCompanyFilter) {
      query += '''JOIN company_state 
      ON company_state.state_id = state.id 
      WHERE company_id = $companyId ''';
    }

    if(countryId != null) {
      query += applyCompanyFilter
          ? 'AND country_id = $countryId '
          : 'WHERE country_id = $countryId ';
    }

    List<StateModel> states = (await dbClient!.rawQuery(query))
      .map((state) => StateModel.fromJson(state))
      .toList();

    if(states.isNotEmpty) {
      return states;
    } else {
      return [];
    }
  }

  /// Clear divisions table data
  Future<int> clearRecords() async {
    final dbClient = await DBProvider().db;
    return await dbClient!.delete('state');
  }
}
