import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job/job_follow_up_status.dart';
import 'package:jobprogress/common/models/job/job_work_flow_history.dart';
import 'package:jobprogress/common/models/job/job_workflow.dart';
import 'package:jobprogress/common/models/workflow/project_stage_status.dart';
import 'package:jobprogress/common/models/workflow/project_stages.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';

void main() {

  JobModel job = mockedJobStages;

  late WorkFlowStagesServiceParams params;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    RunModeService.setRunMode(RunMode.unitTesting);
    params = await WorkFlowStagesService.setUpWorkFlowStagesParams(job);
  });

  group('When workflow stages are loaded with job', () {

    test('WorkFlowStagesServiceParams should set with default value', () {
      expect(params.isProject, false);
      expect(params.isLostJob, false);
      expect(params.listHeight, 160);
    });

    group("setUpJobWorkFlowStages() should set up job workflow stages", () {

      test('When there is no stage in the history, first stage should be selected', () {
        params.job.jobWorkFlowHistory = historyWithEmptyStage;

        WorkFlowStagesService.setUpJobWorkFlowStages(params);
        expect(params.job.jobWorkFlowHistory?.length, 1);
        expect(params.listHeight, 160);
        expect(params.selectedStageCode, currentStageFirst.code);
        expect(params.job.stages?.first.isCurrentStage, true);
        expect(params.job.stages?.last.doShowReinstate, false);
        expect(params.job.stages?.last.doShowMarkAsCompleted, false);
      });

      test('When there is history, next stage to last stage in history should be current stage', () {
        params.job.jobWorkFlowHistory = historyWithMiddleStage;

        WorkFlowStagesService.setUpJobWorkFlowStages(params);
        expect(params.job.jobWorkFlowHistory?.length, historyWithMiddleStage.length);
        expect(params.listHeight, 160);
        expect(params.selectedStageCode, currentStageMiddle.code);
        expect(params.job.stages?[historyWithMiddleStage.length].isCurrentStage, true);
        expect(params.job.stages?.last.doShowReinstate, false);
        expect(params.job.stages?.last.doShowMarkAsCompleted, false);
      });

      group('When all stages are completed', () {

        test("When last stage is not marked as completed", () {
          params.job.jobWorkFlowHistory = historyWithLastStage;
          params.job.jobWorkflow?.lastStageCompletedDate = null;
          params.job.currentStage = currentStageLast;

          WorkFlowStagesService.setUpJobWorkFlowStages(params);
          expect(params.job.jobWorkFlowHistory?.length, historyWithLastStage.length);
          expect(params.listHeight, 160);
          expect(params.job.stages?.last.doShowReinstate, false);
          expect(params.job.stages?.last.doShowMarkAsCompleted, true);
        });

        test("When last stage is marked as completed", () {
          params.job.jobWorkFlowHistory = historyWithLastStage;
          params.job.jobWorkflow?.lastStageCompletedDate = "2022-07-08 00:00:00";
          params.job.currentStage = currentStageLast;

          WorkFlowStagesService.setUpJobWorkFlowStages(params);
          expect(params.job.jobWorkFlowHistory?.length, historyWithLastStage.length);
          expect(params.listHeight, 160);
          expect(params.job.stages?.last.doShowReinstate, true);
          expect(params.job.stages?.last.doShowMarkAsCompleted, false);
        });

      });

    });

    group('setStageDates() should set stage constraints for each stage', () {

      test('For first stage', () {
        WorkFlowStagesService.setStageDates(0, job: params.job);
        expect(params.job.stages?[0].completedDate, historyWithLastStage.first.completedDate);
        expect(params.job.stages?[0].startDate, null);
        expect(params.job.stages?[0].endDate, historyWithLastStage[1].completedDate);
      });

      test('For middle stage', () {
        WorkFlowStagesService.setStageDates(2, job: params.job);
        expect(params.job.stages?[2].completedDate, historyWithLastStage[2].completedDate);
        expect(params.job.stages?[2].startDate, historyWithLastStage[1].completedDate);
        expect(params.job.stages?[2].endDate, historyWithLastStage[3].completedDate);
      });

      test('For last stage', () {
        WorkFlowStagesService.setStageDates(2, job: params.job);
        expect(params.job.stages?.last.completedDate, historyWithLastStage.last.completedDate);
        expect(params.job.stages?.last.startDate, null);
        expect(params.job.stages?.last.endDate, null);
      });

    });

    test('setUpJobStageSelectionList() should setup stages list to select from', () {
      WorkFlowStagesService.setUpJobStageSelectionList(params);

      expect(params.stageSelectionList?.length, params.job.stages?.length);

    });

    group('updateJobStageDates() should update dates after stage updated', () {
      test('For first stage', () {
        WorkFlowStagesService.updateJobStageDates(0, params, tempDate: historyWithLastStage.first.completedDate);
        expect(params.job.stages?[0].completedDate, historyWithLastStage.first.completedDate);
        expect(params.job.stages?[0].startDate, null);
        expect(params.job.stages?[0].endDate, historyWithLastStage[1].completedDate);
      });

      test('For middle stage', () {
        WorkFlowStagesService.updateJobStageDates(2, params, tempDate: historyWithLastStage[2].completedDate);
        expect(params.job.stages?[2].completedDate, historyWithLastStage[2].completedDate);
        expect(params.job.stages?[2].startDate, historyWithLastStage[1].completedDate);
        expect(params.job.stages?[2].endDate, historyWithLastStage[3].completedDate);
      });

      test('For last stage', () {
        WorkFlowStagesService.updateJobStageDates(0, params, tempDate: historyWithLastStage.last.completedDate);
        expect(params.job.stages?.last.completedDate, historyWithLastStage.last.completedDate);
        expect(params.job.stages?.last.startDate, null);
        expect(params.job.stages?.last.endDate, null);
      });
    });

    test('doShowMarkAsCompleted() should check if Mark As Complete button should be displayed', () {
      params.job.jobWorkFlowHistory = historyWithLastStage;
      params.job.jobWorkflow?.lastStageCompletedDate = null;
      params.job.currentStage = currentStageLast;

      final val = WorkFlowStagesService.doShowMarkAsCompleted(params.job);
      expect(val, true);
    });

    test('doShowReInitiate() should check if Reinstate button should be displayed', () {
      params.job.jobWorkFlowHistory = historyWithLastStage;
      params.job.jobWorkflow?.lastStageCompletedDate = "";
      params.job.currentStage = currentStageLast;

      final val = WorkFlowStagesService.doShowReInitiate(params.job);
      expect(val, true);
    });

    test('getSelectedStages() should return list of stage codes that fall in between new stage and current stage', () {
      params.currentStageIndex = 2;
      params.newStageIndex = 5;
      final list = WorkFlowStagesService.getSelectedStages(params);
      expect(list.length, 3);
    });

    test('WorkFlowStagesServiceParams should set with default value in case of lost job', () async {

      params.job.jobLostDate = DateTime.now().toString();

      params = await WorkFlowStagesService.setUpWorkFlowStagesParams(params.job);

      expect(params.isProject, false);
      expect(params.isLostJob, true);
      expect(params.listHeight, 180);
    });

    group('setScrollIndex() should set index to which list is to be scrolled', () {

      test("For first time and first stage is current stage", () {
        WorkFlowStagesService.setScrollIndex(params, firstTime: true);
        expect(params.scrollIndex, 0);
      });

      test("For first time and first stage is not current stage", () {
        params.job.stages?.first.isCurrentStage = false;
        WorkFlowStagesService.setScrollIndex(params, firstTime: true);
        expect(params.scrollIndex, params.job.jobWorkFlowHistory!.length);
      });

      test("After stage switch", () {
        WorkFlowStagesService.setScrollIndex(params);
        expect(params.scrollIndex, 5);
      });

    });

    group('setCurrentNewStageIndex() should set current and new stage index for job stages', () {

      test('When there is no new stage', () {
        WorkFlowStagesService.setCurrentNewStageIndex(params);
        expect(params.newStageIndex, job.stages!.length - 1);
        expect(params.currentStageIndex, job.stages!.length - 1);
        expect(params.forMarkAsComplete, null);
        expect(params.scrollIndex, params.newStageIndex);
      });

      test('When there is new stage', () {
        WorkFlowStagesService.setCurrentNewStageIndex(params, newStageCode: '14');
        expect(params.newStageIndex, 3);
        expect(params.currentStageIndex, 5);
        expect(params.forMarkAsComplete, null);
        expect(params.scrollIndex, params.newStageIndex);
      });

      test('While marking stage as completed', () {
        WorkFlowStagesService.setCurrentNewStageIndex(params, newStageCode: '14', isForMarkAsComplete: true);
        expect(params.newStageIndex, 3);
        expect(params.currentStageIndex, 5);
        expect(params.forMarkAsComplete, true);
        expect(params.scrollIndex, params.newStageIndex);
      });

      test('While marking last stage as reinstate', () {
        WorkFlowStagesService.setCurrentNewStageIndex(params, newStageCode: '14', isForMarkAsComplete: false);
        expect(params.newStageIndex, 3);
        expect(params.currentStageIndex, 5);
        expect(params.forMarkAsComplete, false);
        expect(params.scrollIndex, params.newStageIndex);
      });

    });

  });

  group("When workflow stages are loaded with project", () {

    test("setUpProjectWorkFlowStages() should set up project workflow stages", () {

      params.job = mockedProjectStages;
      params.projectStages = projectStages;

      WorkFlowStagesService.setUpProjectWorkFlowStages(params);

      expect(params.projectStages?.first.isCurrentStage, true);
      expect(params.selectedStageCode, params.projectStages?.first.id.toString());
    });

    test('setUpProjectStageSelectionList() should setup project stages list to select from', () {
      WorkFlowStagesService.setUpProjectStageSelectionList(params);
      expect(params.stageSelectionList?.length, params.projectStages?.length);
    });

    group('setScrollIndex() should set index to which list is to be scrolled', () {

      test("For first time", () {
        WorkFlowStagesService.setScrollIndex(params, firstTime: true);
        expect(params.scrollIndex, params.job.jobWorkFlowHistory!.length);
      });

      test("After stage switch", () {
        WorkFlowStagesService.setScrollIndex(params);
        expect(params.scrollIndex, 5);
      });

    });

  });

  group("Workflow Division Feature Tests", () {
    late JobModel divisionTestJob;
    late WorkFlowStagesServiceParams divisionParams;

    setUp(() {
      divisionTestJob = JobModel(
        id: 123,
        customerId: 1,
        customer: CustomerModel(),
        division: DivisionModel(id: 1, name: 'Test Division', code: 'TEST'),
        followUpStatus: JobFollowUpStatus(mark: ""),
        jobWorkFlowHistory: historyWithMiddleStage,
        jobWorkflow: JobWorkFlow(),
        stagesByDivision: [
          WorkFlowStageModel(name: 'Stage A', color: "cl-blue", code: 'SA'),
          WorkFlowStageModel(name: 'Stage B', color: "cl-green", code: 'SB'),
          WorkFlowStageModel(name: 'Stage C', color: "cl-yellow", code: 'SC'),
        ],
        currentStage: WorkFlowStageModel(name: 'Stage A', color: "cl-blue", code: 'SA'),
        createdDate: "2022-07-01 00:00:00",
      );
    });

    group("WorkFlowStagesService@setUpDivisionChangedWorkflow should configure division-specific workflow parameters", () {
      test("Should create params with isDivisionWorkflowUpdate flag set to true", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.isDivisionWorkflowUpdate, isTrue);
        expect(divisionParams.job.id, equals(123));
        expect(divisionParams.selectedStageCode, equals('SA'));
      });

      test("Should preserve current stage code in selected stage", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.selectedStageCode, equals(divisionTestJob.currentStage?.code));
      });

      test("Should handle null current stage gracefully", () async {
        divisionTestJob.currentStage = null;
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.selectedStageCode, equals(""));
      });

      test("Should set up stage selection list for division workflow", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.stageSelectionList, isNotNull);
        expect(divisionParams.stageSelectionList?.length, equals(divisionTestJob.stagesByDivision?.length));
      });
    });

    group("WorkFlowStagesServiceParams division workflow properties", () {
      test("Should initialize with default isDivisionWorkflowUpdate as false", () {
        final normalParams = WorkFlowStagesServiceParams(job: divisionTestJob);

        expect(normalParams.isDivisionWorkflowUpdate, isFalse);
      });

      test("Should allow setting isDivisionWorkflowUpdate to true", () {
        final divisionParams = WorkFlowStagesServiceParams(
          job: divisionTestJob,
          isDivisionWorkflowUpdate: true,
        );

        expect(divisionParams.isDivisionWorkflowUpdate, isTrue);
      });

      test("Should maintain all other properties when isDivisionWorkflowUpdate is set", () {
        final divisionParams = WorkFlowStagesServiceParams(
          job: divisionTestJob,
          isDivisionWorkflowUpdate: true,
          selectedStageCode: 'TEST_STAGE',
          scrollIndex: 2,
        );

        expect(divisionParams.isDivisionWorkflowUpdate, isTrue);
        expect(divisionParams.selectedStageCode, equals('TEST_STAGE'));
        expect(divisionParams.scrollIndex, equals(2));
        expect(divisionParams.job.id, equals(123));
      });
    });

    group("Stage selection list setup for division workflow", () {
      test("WorkFlowStagesService@setUpJobStageSelectionList should work with division workflow params", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.stageSelectionList, isNotNull);
        expect(divisionParams.stageSelectionList?.isNotEmpty, isTrue);
      });

      test("Stage selection list should contain all available stages", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        final stageList = divisionParams.stageSelectionList;
        expect(stageList?.length, equals(3));
        expect(stageList?.first.label, equals('Stage A'));
        expect(stageList?.first.id, equals('SA'));
      });

      test("Should handle empty stages list gracefully", () async {
        divisionTestJob.stagesByDivision = [];
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.stageSelectionList, isNotNull);
        expect(divisionParams.stageSelectionList?.isEmpty, isTrue);
      });
    });

    group("Division workflow parameter validation", () {
      test("Should validate job ID for division workflow operations", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.job.id, isNotNull);
        expect(divisionParams.job.id, greaterThan(0));
      });

      test("Should validate division information is present", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.job.division, isNotNull);
        expect(divisionParams.job.division?.id, isNotNull);
        expect(divisionParams.job.division?.name, isNotNull);
      });

      test("Should handle missing division information gracefully", () async {
        divisionTestJob.division = null;
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        expect(divisionParams.job.division, isNull);
        expect(divisionParams.isDivisionWorkflowUpdate, isTrue);
      });
    });

    group("Division workflow integration with existing workflow methods", () {
      test("WorkFlowStagesService@setCurrentNewStageIndex should work with division workflow params", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        WorkFlowStagesService.setCurrentNewStageIndex(divisionParams, newStageCode: 'SB');

        expect(divisionParams.newStageIndex, equals(1));
        expect(divisionParams.currentStageIndex, isNotNull);
      });

      test("WorkFlowStagesService@getSelectableStagesList should work with division workflow params", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        final selectableStages = WorkFlowStagesService.getSelectableStagesList(divisionParams);

        expect(selectableStages, isNotNull);
        expect(selectableStages.isNotEmpty, isTrue);
      });

      test("Division workflow should maintain stage width calculations", () async {
        divisionParams = await WorkFlowStagesService.setUpDivisionChangedWorkflow(divisionTestJob);

        final stageWidth = WorkFlowStagesService.getStageWidth(divisionParams);

        expect(stageWidth, greaterThan(0));
      });
    });
  });

}

final mockedJobStages = JobModel(
    id: 1,
    customerId: 1,
    customer: CustomerModel(),
    parent: null,
    jobWorkFlowHistory: historyWithLastStage,
    jobWorkflow: JobWorkFlow(),
    stages: [
    WorkFlowStageModel(name: 'A', color: "cl-red", code: '11'),
    WorkFlowStageModel(name: 'B', color: "cl-red", code: '12'),
    WorkFlowStageModel(name: 'C', color: "cl-red", code: '13'),
    WorkFlowStageModel(name: 'D', color: "cl-red", code: '14'),
    WorkFlowStageModel(name: 'E', color: "cl-red", code: '15'),
    WorkFlowStageModel(name: 'F', color: "cl-red", code: '16'),
  ],
  currentStage: currentStageMiddle,
  createdDate: "2022-07-01 00:00:00"
);

final mockedProjectStages = JobModel(
    id: 1,
    customerId: 1,
    customer: CustomerModel(),
    parentId: 1,
    parent: JobModel(
        id: 1,
        projectStatus: ProjectStatusModel(
          status: ProjectStageModel(
            id: 1,
            name: ''
          )
        ),
        parentId: 1,
        customerId: 1,
        customer: CustomerModel(),
        parent: null,
        
        jobWorkFlowHistory: historyWithLastStage,
        jobWorkflow: JobWorkFlow(),
        stages: [
          WorkFlowStageModel(name: 'A', color: "cl-red", code: '11'),
          WorkFlowStageModel(name: 'B', color: "cl-red", code: '12'),
          WorkFlowStageModel(name: 'C', color: "cl-red", code: '13'),
          WorkFlowStageModel(name: 'D', color: "cl-red", code: '14'),
          WorkFlowStageModel(name: 'E', color: "cl-red", code: '15'),
          WorkFlowStageModel(name: 'F', color: "cl-red", code: '16'),
        ],
        currentStage: currentStageMiddle,
        createdDate: "2022-07-01 00:00:00"
    ),
    followUpStatus: JobFollowUpStatus(
        mark: ""
    ),
    jobWorkFlowHistory: historyWithLastStage,
    jobWorkflow: JobWorkFlow(),
    stages: [
      WorkFlowStageModel(name: 'A', color: "cl-red", code: '11'),
      WorkFlowStageModel(name: 'B', color: "cl-red", code: '12'),
      WorkFlowStageModel(name: 'C', color: "cl-red", code: '13'),
      WorkFlowStageModel(name: 'D', color: "cl-red", code: '14'),
      WorkFlowStageModel(name: 'E', color: "cl-red", code: '15'),
      WorkFlowStageModel(name: 'F', color: "cl-red", code: '16'),
    ],
    currentStage: currentStageMiddle,
    createdDate: "2022-07-01 00:00:00"
);

final projectStages = [
  ProjectStageModel(id: 1),
  ProjectStageModel(id: 2),
  ProjectStageModel(id: 3),
];

final historyWithEmptyStage = <JobWorkFlowHistoryModel>[];

final historyWithMiddleStage = [
  JobWorkFlowHistoryModel(id: 11, stage: 'A', completedDate: "2022-07-03 00:00:00", createdAt: "2022-07-01 00:00:00"),
  JobWorkFlowHistoryModel(id: 12, stage: 'B', completedDate: "2022-07-05 00:00:00", createdAt: "2022-07-01 00:00:00"),
  JobWorkFlowHistoryModel(id: 13, stage: 'c', completedDate: "2022-07-06 00:00:00", createdAt: "2022-07-01 00:00:00"),
];

final historyWithLastStage = [
  ...historyWithMiddleStage,
  JobWorkFlowHistoryModel(id: 14, stage: 'D', completedDate: "2022-07-08 00:00:00", createdAt: "2022-07-01 00:00:00"),
  JobWorkFlowHistoryModel(id: 15, stage: 'E', completedDate: "2022-07-08 00:00:00", createdAt: "2022-07-01 00:00:00",),
];

final currentStageFirst = WorkFlowStageModel(name: 'A', color: "cl-red", code: '11');
final currentStageMiddle = WorkFlowStageModel(name: 'D', color: "cl-red", code: '14');
final currentStageLast = WorkFlowStageModel(name: 'F', color: "cl-red", code: '16');
