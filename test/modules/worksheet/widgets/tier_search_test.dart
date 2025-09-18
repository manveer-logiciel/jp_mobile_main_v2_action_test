import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/worksheet/widgets/tiers_search/controller.dart';

void main() {
  final controller = TiersSearchController();

  setUpAll(() {
    controller.tiers = [
      'Tier 1',
      'Tier 2',
      'Tier 3'
    ];
    controller.onInit();
  });

  group("TiersSearchController@getSelectedTierName should give correct tier name", () {
    test("In case tier is selected without search, tier name should be selected tier name", () {
      String? tierName = controller.getSelectedTierName(index: 2);
      expect(tierName, 'Tier 3');
    });

    test("In case searched tier is not available, tier name should be same as added tier name", () {
      controller.searchTextController.text = 'Tier 4';
      controller.search(controller.searchTextController.text);
      String? tierName = controller.getSelectedTierName();
      expect(tierName, 'Tier 4');
    });

    test("In case searched tier is available, Tier name should be same as selected tier name", () {
      controller.searchTextController.text = 'Tier 2';
      controller.search(controller.searchTextController.text);
      String? tierName = controller.getSelectedTierName(index: 0);
      expect(tierName, 'Tier 2');
    });
  });

}