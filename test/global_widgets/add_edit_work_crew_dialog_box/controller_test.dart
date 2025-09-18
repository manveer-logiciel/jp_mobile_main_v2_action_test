import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/global_widgets/add_edit_work_crew_dialog_box/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main(){

  final controller = AddEditWorkCrewDialogBoxController(
    companyCrewList: [], 
    subcontractorList: [], 
    jobModel: JobModel(id: 1, customerId: 1234), 
    onFinish: (NoteListModel noteListModel) { });

  group('AddEditWorkCrewDialogBoxController@setData should set form data correctly', () {

    test('When selected Company Crew is available but selected Labor Contractors is not available.', () {
      // Arrange
      final selectedCompanyCrew = [
        JPMultiSelectModel(id: '1', label: 'Rep 1', isSelect: true),
        JPMultiSelectModel(id: '2', label: 'Rep 2', isSelect: true),
      ];

      controller.companyCrewList.addAll(selectedCompanyCrew);

      // Act
      controller.setData();

      // Assert
      expect(controller.repIds, equals([1, 2]));
      expect(controller.subIds, isEmpty);
    });

    test('When the selected CompanyCrew is not available but the selected Labor Contractors is available.', () {
      // Arrange
      controller.companyCrewList.clear();
      
      final selectedLaborContractors = [
        JPMultiSelectModel(id: '3', label: 'Contractor 1', isSelect: true),
        JPMultiSelectModel(id: '4', label: 'Contractor 2', isSelect: true),
      ];

      controller.subcontractorList.addAll(selectedLaborContractors);
      // Act
      controller.setData();

      // Assert
      expect(controller.repIds, isEmpty);
      expect(controller.subIds, equals([3, 4]));
    });

    test('When both selected CompanyCrew and LaborContractors are not available', () {
      // Arrange
      controller.companyCrewList.clear();
      controller.subcontractorList.clear();

      // Act
      controller.setData();
      // Assert
      expect(controller.repIds, isEmpty);
      expect(controller.subIds, isEmpty);
    });

    test('When both selected CompanyCrew and LaborContractors are available', () {
      final selectedCompanyCrew = [
        JPMultiSelectModel(id: '1', label: 'Rep 1', isSelect: true),
        JPMultiSelectModel(id: '2', label: 'Rep 2', isSelect: true),
      ];

      final selectedLaborContractors = [
        JPMultiSelectModel(id: '3', label: 'Contractor 1', isSelect: true),
        JPMultiSelectModel(id: '4', label: 'Contractor 2', isSelect: true),
      ];

      controller.companyCrewList.addAll(selectedCompanyCrew);
      controller.subcontractorList.addAll(selectedLaborContractors);
      // Act
      controller.setData();

      // Assert
      expect(controller.repIds, equals([1, 2]));
      expect(controller.subIds, equals([3, 4]));
    });
    
    test('When setData clears rep and sub ids', () 
    { 
      // Arrange
      controller.companyCrewList.clear();
      controller.subcontractorList.clear();
      controller.repIds.addAll([1, 2, 3]);
      controller.subIds.addAll([4, 5, 6]);

      // Act
      controller.setData();

      // Assert
      expect(controller.repIds, isEmpty);
      expect(controller.subIds, isEmpty);
    });   
  });

  group('AddEditWorkCrewDialogBoxController@removeSelectedWorkCrew should remove id from repIds and subIds', () {
    test('When id is removed from repIds only.', () {
      // Arrange
      controller.repIds = [1, 2, 3];
      controller.subIds = [4, 5, 6];
      const idToRemove = '2';

      // Act
      controller.removeSelectedWorkCrew(idToRemove);

      // Assert
      expect(controller.repIds, equals([1, 3]));
      expect(controller.subIds, equals([4, 5, 6]));
    });

    test('When id is removed from subIds only.', () {
      // Arrange
      controller.repIds = [1, 2, 3];
      controller.subIds = [4, 5, 6];
      const idToRemove = '5';

      // Act
      controller.removeSelectedWorkCrew(idToRemove);

      // Assert
      expect(controller.repIds, equals([1, 2, 3]));
      expect(controller.subIds, equals([4, 6]));
    });

    test('Sould not remove id if not present in repIds or subIds.', () {
      // Arrange
      controller.repIds = [1, 2, 3];
      controller.subIds = [4, 5, 6];
      const idToRemove = '7';

      // Act
      controller.removeSelectedWorkCrew(idToRemove);

      // Assert
      expect(controller.repIds, equals([1, 2, 3]));
      expect(controller.subIds, equals([4, 5, 6]));
    });

  });

  group('AddEditWorkCrewDialogBoxController@getAddEditWorkCrewParams should return params for add edit work crew', () {
    test('Should returns params while adding work crew.', () {
      // Arrange
      controller.jobModel = JobModel(id: 1, customerId: 1);
      controller.repIds = [1, 2, 3];
      controller.subIds = [4, 5, 6];
      const isEdit = false;

      // Act
      final result = controller.getAddEditWorkCrewParams(isEdit: isEdit);

      // Assert
      expect(result, {
        'job_id': 1,
        'rep_ids[]': '',
        'sub_contractor_ids[]': '',
        'rep_ids[0]': 1,
        'rep_ids[1]': 2,
        'rep_ids[2]': 3,
        'sub_contractor_ids[0]': 4,
        'sub_contractor_ids[1]': 5,
        'sub_contractor_ids[2]': 6,
      });
    });

    test('Should returns params while editing work crew.', () {
      // Arrange
      controller.jobModel = JobModel(id: 1, customerId: 1);
      controller.repIds = [1, 2, 3];
      controller.subIds = [4, 5, 6];
      const isEdit = true;

      // Act
      final result = controller.getAddEditWorkCrewParams(isEdit: isEdit);

      // Assert
      expect(result, {
        'job_id': 1,
        'rep_ids[]': '',
        'sub_contractor_ids[]': '',
        'rep_ids[0]': 1,
        'rep_ids[1]': 2,
        'rep_ids[2]': 3,
        'sub_contractor_ids[0]': 4,
        'sub_contractor_ids[1]': 5,
        'sub_contractor_ids[2]': 6,
        'id': 1, // id field for editing
      });
    });

    test('Should not returns params when job is not available.', () {
      // Arrange
      controller.jobModel = null;
      controller.repIds.clear();
      controller.subIds.clear();
      const isEdit = false;

      // Act
      final result = controller.getAddEditWorkCrewParams(isEdit: isEdit);

      // Assert
      expect(result, {
        'job_id': null,
        'rep_ids[]': '',
        'sub_contractor_ids[]': '',
      });
    });
  });
}
