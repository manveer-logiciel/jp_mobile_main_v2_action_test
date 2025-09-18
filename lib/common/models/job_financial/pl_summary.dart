import 'package:jobprogress/common/models/job_financial/pl_summary_actual.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_financial_summary.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_project.dart';

class PlSummaryModel {
  PlSummaryProjectModel projected;
  PlSummaryActualModel actual;
  PlSummaryFinancialSummaryModel summary;

  PlSummaryModel({
    required this.summary,
    required this.actual,
    required this.projected
  });
}