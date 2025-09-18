import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';

void main() {
  group('JobModel@JobModel.fromJson parsing check', () {
    test('Should parse work crew and work crew names when work crew is available', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 1,
        'customer_id': 2,
        "reps": {
          "data": [
            {'id': 3, 'full_name': 'Rep 1',},
            {'id': 4, 'full_name': 'Rep 2',}
          ]
        },
        "sub_contractors": {
          "data": [
            {'id': 5, 'full_name': 'Sub 1', 'company_name': null},
            {'id': 6, 'full_name': 'Sub 2', 'company_name': 'Sub 2 Company'},
          ]
        },
      };

      // Act
      final jobModel = JobModel.fromJson(json);

      // Assert
      expect(jobModel.workCrew, isNotNull);
      expect(jobModel.workCrewNames, isNotNull);
      expect(
        jobModel.workCrewNames,
        equals(
          'Rep 1, Rep 2, Sub 1, Sub 2 (Sub 2 Company)',
        ),
      );
    });

    test('Should parse work crew and work crew names when reps is available but sub contractors is not', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 1,
        'customer_id': 2,
        "reps": {
          "data": [
            {'id': 3, 'full_name': 'Rep 1','company_name': null},
          ]
        },
        "sub_contractors": {
          "data": <dynamic>[]
        },
      };

      // Act
      final jobModel = JobModel.fromJson(json);

      // Assert
      expect(jobModel.workCrew, isNotNull);
      expect(jobModel.workCrewNames, isNotNull);
      expect(
        jobModel.workCrewNames,
        equals(
          'Rep 1',
        ),
      );
    });

    test('Should parse work crew and work crew names when sub contractors is available but reps is not', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 1,
        'customer_id': 2,
        "reps": {
          "data": <dynamic>[]
        },
        "sub_contractors": {
          "data": [
            {'id': 5, 'full_name': 'Sub 1', 'company_name': null},
          ]
        },
      };

      // Act
      final jobModel = JobModel.fromJson(json);

      // Assert
      expect(jobModel.workCrew, isNotNull);
      expect(jobModel.workCrewNames, isNotNull);
      expect(
        jobModel.workCrewNames,
        equals(
          'Sub 1',
        ),
      );
    });

    test('Should show unassigned to workCrew when work crew is not available', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'customer_id': 2,
        "reps": {
          "data": <dynamic>[]
        },
        "sub_contractors": {
          "data": <dynamic>[]
        },
      };

      final jobModel = JobModel.fromJson(json);
      
      expect(jobModel.workCrewNames, 'unassigned');
    });

    test('Should show unassigned to workCrew when work crew is not available', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 1,
        'customer_id': 2,
        "reps": null,
        "sub_contractors": null,
        'customer': {'rep': null},
      };

      // Act
      final jobModel = JobModel.fromJson(json);

      // Assert  
      expect(jobModel.workCrewNames, 'unassigned');
    });
  });

  group('JobModel@jobAddress should give the appropriate address to list on Job Details Tile', () {
    test('Should return fullJobAddress when it is available', () {
      final jobModel = JobModel(
        id: 1,
        customerId: 2,
      );
      jobModel.fullJobAddress = '123 Main St, City, State';
      jobModel.addressString = 'Different Address';

      expect(jobModel.jobAddress, equals('123 Main St, City, State'));
    });

    test('Should return addressString when fullJobAddress is null', () {
      final jobModel = JobModel(
        id: 1,
        customerId: 2,
      );
      jobModel.fullJobAddress = null;
      jobModel.addressString = '456 Oak St, Town, State';

      expect(jobModel.jobAddress, equals('456 Oak St, Town, State'));
    });

    test('Should return null when both fullJobAddress and addressString are null', () {
      final jobModel = JobModel(
        id: 1,
        customerId: 2,
      );
      jobModel.fullJobAddress = null;
      jobModel.addressString = null;

      expect(jobModel.jobAddress, isNull);
    });
  });
}

