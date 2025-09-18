import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/modules/project/project_form_tab/controller.dart';

void main(){
  ProjectTabController controller = ProjectTabController([], [{}], JobFormType.add, "");

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller.onInit();
  });

  test('ProjectTabController should be initialized with correct values', () {
    expect(controller.isSectionExpanded, isFalse);
    expect(controller.projectCount, 1);
    expect(controller.projectWithKey.length,1);
    expect(controller.selectedIndex, 0);
  });

  test('ProjectTabController@onAddProject should add project', () {
    controller.onAddProject();
    expect(controller.isSectionExpanded, isTrue);
    expect(controller.projectCount, 2);
    expect(controller.projectWithKey.length,2);
    expect(controller.selectedIndex, 1);
  });

  test('ProjectTabController@onRemoveProject should add project', () {
    controller.onRemoveProject(1);
    expect(controller.projectCount, 1);
    expect(controller.projectWithKey.length,1);
    expect(controller.selectedIndex, 0);
  });

  group('ProjectTabController@onSectionExpansionChanged should toggle section\'s expansion', () {

      test('Section should be expanded', () {
        controller.onSectionExpansionChanged(true);
        expect(controller.isSectionExpanded, true);
      });

      test('Section should be collapsed', () {
        controller.onSectionExpansionChanged(false);
        expect(controller.isSectionExpanded, false);
      });
    });
}