import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/global_widgets/day_count_down/controller.dart';

void main() {
  JPDayCountDownController controller = JPDayCountDownController();
  
  group('JPDayCountDownController@calculateDaysLeft should return correct days left in trial', () {
    test('when remainingDays is 29', () {
      int remaining = 29;
      final result = controller.calculateDaysLeft(remaining);
      expect(result.contains('29 days'), true);
    });
    test('when remainingDays is 1', () {
      int remaining = 1;
      final result = controller.calculateDaysLeft(remaining);
      expect(result.contains('1 day'), true);
    });

    test('when remainingDays is 0', () {
      int remaining = 0;
      final result = controller.calculateDaysLeft(remaining);
      expect(result.contains('0 day'), true);
    });

    test('when remainingDays is null', () {
      int ? remaining;
      final result = controller.calculateDaysLeft(remaining);
      expect(result, '');
    });

  });

  group('JPDayCountDownController@shouldWidgetBeVisible should return correct visibility', () {
    test('should return true when remainingDays is not null or empty, visibility is true', () {
      int ? remainingDays = 20;
      const visibility = true;
      final result = controller.shouldWidgetBeVisible(remainingDays, visibility);
      expect(result, true);
    });

    test('should return false when remainingDays is null', () {
      int ? remainingDays ;
      const visibility = true;
      final result = controller.shouldWidgetBeVisible(remainingDays, visibility);
      expect(result, false);
    });


    test('should return false when visibility is false', () {
      int ? remainingDays = 20;
      const visibility = false;
      final result = controller.shouldWidgetBeVisible(remainingDays, visibility);
      expect(result, false);
    });
  });
}
