import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/test_base.dart';

class FlutterToastTestCase extends TestBase {

  String flutterToastTestDesc = 'Toast should be visible';

  Future<void> showToast(WidgetTester widgetTester) async {
        expect(await Fluttertoast.showToast(msg: "Flutter toast is visible"),true);

        await widgetTester.pumpAndSettle();
        await testConfig.fakeDelay(2);
  }

  @override
  void runTest({bool isMock = true}) {
    testWidgets(flutterToastTestDesc, (widgetTester) async {
      await showToast(widgetTester);
    });
  }
}