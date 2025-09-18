import 'package:get/get.dart';
import '../config/test_config.dart';

abstract class TestBase {

  TestConfig testConfig = Get.find();

  void runTest({bool isMock = true});
}