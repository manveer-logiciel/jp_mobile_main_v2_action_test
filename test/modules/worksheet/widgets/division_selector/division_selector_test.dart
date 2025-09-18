import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/modules/worksheet/widgets/division_selector/controller.dart';

void main() {
  late WorksheetDivisionSelectorController controller;
  late DivisionModel jobDivision;
  late DivisionModel favouriteDivision;

  setUpAll(() {
    jobDivision = DivisionModel(
      id: 1,
      name: 'Job Division',
      addressString: '123 Job St',
      email: 'job@company.com',
      phone: '123-456-7890',
    );

    favouriteDivision = DivisionModel(
      id: 2,
      name: 'Favourite Division',
      addressString: '456 Favourite Ave',
      email: 'favourite@company.com',
      phone: '098-765-4321',
    );

    controller = WorksheetDivisionSelectorController(
      jobDivision: jobDivision,
      favouriteDivision: favouriteDivision,
    );
  });

  test('WorksheetDivisionSelectorController should initialize all values correctly', () {
    expect(controller.jobDivision, jobDivision);
    expect(controller.favouriteDivision, favouriteDivision);
    expect(controller.selectedDivisionId, isNull);
    expect(controller.isApplyButtonDisabled, isTrue);
  });

  test('WorksheetDivisionSelectorController@onTapDivision should update the selected division and refreshes UI', () {
    controller.onTapDivision(1);
    expect(controller.selectedDivisionId, 1);
    expect(controller.isApplyButtonDisabled, isFalse);
  });

  test('WorksheetDivisionSelectorController@getSelectedDivision gives correct division', () {
    controller.onTapDivision(1);
    expect(controller.getSelectedDivision(), jobDivision);

    controller.onTapDivision(2);
    expect(controller.getSelectedDivision(), favouriteDivision);
  });

  test('WorksheetDivisionSelectorController@defaultDivision gives default division that to be displayed in case of empty data', () {
    AuthService.userDetails = UserModel(
      id: 1,
      firstName: 'Test',
      fullName: 'User',
      email: '123@gmail.com',
      companyDetails: CompanyModel(
        id: 1,
        phone: '111-222-3333',
        email: 'default@company.com',
        address: '789 Default Blvd',
        companyName: '',
      ),
    );

    final defaultDivision = controller.defaultDivision;
    expect(defaultDivision.phone, '111-222-3333');
    expect(defaultDivision.email, 'default@company.com');
    expect(defaultDivision.addressString, '789 Default Blvd');
  });
}