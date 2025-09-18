
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/workflow/project_stages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorkFlowStagesServiceParams {

  JobModel job;
  int scrollIndex;
  double duration;
  String selectedStageCode;
  List<JPSingleSelectModel>? stageSelectionList;
  int incompleteTaskLockCount;
  int currentStageIndex;
  int newStageIndex;
  bool? forMarkAsComplete;
  double listHeight;
  double stageWidth;
  bool disableScroll;
  bool isProject;
  bool isLostJob;
  bool isDivisionWorkflowUpdate;
  /// Controls whether to show workflow automation dialogs during stage changes
  /// Used to conditionally enable/disable automation based on context
  bool showWorkFlowAutomation;
  List<ProjectStageModel>? projectStages;

  WorkFlowStagesServiceParams({
    required this.job,
    this.scrollIndex = 0,
    this.selectedStageCode = '',
    this.duration = 0,
    this.stageSelectionList,
    this.incompleteTaskLockCount = 0,
    this.currentStageIndex = 0,
    this.newStageIndex = 0,
    this.forMarkAsComplete,
    this.listHeight = 0,
    this.stageWidth = 0,
    this.isProject = false,
    this.projectStages,
    this.isLostJob = false,
    this.disableScroll = false,
    this.isDivisionWorkflowUpdate = false,
    this.showWorkFlowAutomation = true,
  });
}