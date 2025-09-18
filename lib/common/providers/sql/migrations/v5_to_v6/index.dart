import 'package:jobprogress/common/providers/sql/migrations/base/index.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/tables.dart';
import 'package:sqflite/sqflite.dart';

/// [DbMigrationV5toV6] will be responsible for migrating DB from version 5 to 6
/// This migration adds group support to workflow_stages table and forces a re-sync
/// to populate group data for existing users
class DbMigrationV5toV6 extends DBMigrationBase {
  @override
  Future<void> onCreate(Batch batch) async {
    // This method is called when creating the database from scratch
    // Group columns will be included in the initial table creation
    return;
  }

  @override
  Future<void> onDowngrade(Batch batch) async {
    // Remove group columns if downgrading
    await removeGroupColumnsFromWorkflowStages(batch);
  }

  @override
  Future<void> onUpgrade(Database db, Batch batch) async {
    // Add group columns to existing workflow_stages table
    await addGroupColumnsToWorkflowStages(batch);
    
    // Force re-sync of workflow stages to populate group data
    await forceWorkflowStagesResync(batch);
  }

  /// Add group-related columns to workflow_stages table
  Future<void> addGroupColumnsToWorkflowStages(Batch batch) async {
    // Note: SQLite doesn't support adding multiple columns in a single ALTER TABLE statement
    // Each column must be added separately, but they're all in the same batch for efficiency
    batch.execute('ALTER TABLE workflow_stages ADD COLUMN color_type TEXT');
    batch.execute('ALTER TABLE workflow_stages ADD COLUMN group_id INTEGER');
    batch.execute('ALTER TABLE workflow_stages ADD COLUMN group_name TEXT');
    batch.execute('ALTER TABLE workflow_stages ADD COLUMN group_color TEXT');
  }

  /// Remove group-related columns from workflow_stages table (for downgrade)
  Future<void> removeGroupColumnsFromWorkflowStages(Batch batch) async {
    // Use modern SQLite DROP COLUMN support (available since SQLite 3.35.0)
    batch.execute('ALTER TABLE workflow_stages DROP COLUMN color_type');
    batch.execute('ALTER TABLE workflow_stages DROP COLUMN group_id');
    batch.execute('ALTER TABLE workflow_stages DROP COLUMN group_name');
    batch.execute('ALTER TABLE workflow_stages DROP COLUMN group_color');
  }

  /// Force re-sync of workflow stages to populate group data for existing users
  Future<void> forceWorkflowStagesResync(Batch batch) async {
    // Get company ID for the current user
    final companyId = AuthService.userDetails?.companyDetails?.id;
    
    if (companyId != null) {
      // Clear the table_update_status for workflow_stages to force a re-sync
      // This ensures that existing users get the group data from the server
      batch.delete(
        'table_update_status',
        where: 'table_name = ? AND company_id = ?',
        whereArgs: [SqlTable.workFlowStages, companyId],
      );
    }
  }
}
