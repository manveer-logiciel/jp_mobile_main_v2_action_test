import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/ColorPicker/flex_color_picker.dart';
import 'package:sqflite/sqflite.dart';

class SqlWorkFlowStagesRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<WorkFlowStageModel> stages) async {
    final dbClient = await DBProvider().db;
    int companyId = await AuthService.getCompanyId();

    Batch batch = dbClient!.batch();

    for (var i = 0; i < stages.length; i++) {
       final stage = {
        ...stages[i].toJson(),
        'company_id': companyId
      };
      batch.insert('workflow_stages', stage);
    }

    return await batch.commit(continueOnError: true);
  }

  /// Getting records from local DB
  Future<List<WorkFlowStageModel?>> get() async {

    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;

    String query = 'SELECT * FROM workflow_stages WHERE company_id = $companyId';

    List<WorkFlowStageModel> stages = (await dbClient!.rawQuery(query))
      .map((stage) => WorkFlowStageModel.fromJson(stage))
      .toList();

    if(stages.isNotEmpty) {
      return stages;
    } else {
      return [];
    }
  }

  /// Getting one record from local db
  Future<WorkFlowStageModel?> getOne(int id) async {
    final dbClient = await DBProvider().db;

    List<WorkFlowStageModel> stages = (await dbClient!.rawQuery('SELECT * FROM workflow_stages where id = $id'))
      .map((stage) => WorkFlowStageModel.fromJson(stage))
      .toList();

    if(stages.isNotEmpty) {
      return stages[0];
    } else {
      return null;
    }
  }

  /// Get stages grouped by their groups for hierarchical display
  Future<Map<String, List<WorkFlowStageModel>>> getGroupedStages() async {
    final stages = await get();
    final Map<String, List<WorkFlowStageModel>> groupedStages = {};

    for (final stage in stages) {
      if (stage != null) {
        final groupName = stage.groupName ?? CommonConstants.unAssignedStageGroup.capitalize;
        if (!groupedStages.containsKey(groupName)) {
          groupedStages[groupName] = [];
        }
        groupedStages[groupName]!.add(stage);
      }
    }

    return groupedStages;
  }

  /// Get stages by specific group ID
  Future<List<WorkFlowStageModel?>> getByGroupId(int groupId) async {
    int companyId = AuthService.userDetails!.companyDetails!.id;
    final dbClient = await DBProvider().db;

    String query = 'SELECT * FROM workflow_stages WHERE company_id = $companyId AND group_id = $groupId';

    List<WorkFlowStageModel> stages = (await dbClient!.rawQuery(query)).map((stage) => WorkFlowStageModel.fromJson(stage)).toList();

    return stages;
  }

  /// Get all unique groups from workflow stages
  Future<List<Map<String, dynamic>>> getUniqueGroups() async {
    int companyId = AuthService.userDetails!.companyDetails!.id;
    final dbClient = await DBProvider().db;

    String query = '''
      SELECT DISTINCT group_id, group_name, group_color 
      FROM workflow_stages 
      WHERE company_id = $companyId 
      AND group_id IS NOT NULL 
      ORDER BY group_name
    ''';

    return await dbClient!.rawQuery(query);
  }

  /// Clear divisions table data
  Future<int> clearRecords() async {

    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
        'workflow_stages',
        where: "company_id = ?",
        whereArgs: [companyId]
    );
  }
}
