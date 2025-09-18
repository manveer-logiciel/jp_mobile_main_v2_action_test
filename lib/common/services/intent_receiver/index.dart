import 'dart:async';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/routes/pages.dart';

class IntentReceiverService {

  static late StreamSubscription<List<SharedFile>> intentDataStreamSubscription;

  static List<String>? filePaths; // For storing shared files path

  static void setUp() {
    // For sharing images coming from outside the app while the app is in the memory
    intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream().listen(
        (List<SharedFile> value) {
      navigateToCustomerJobSearch(value);
    }, onError: (dynamic err) {
      Helper.handleError(err);
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) {
      if (value.isNotEmpty) {
        navigateToCustomerJobSearch(value);
      }
    });
  }

  static Future<void> navigateToCustomerJobSearch(List<SharedFile> sharedFiles) async {
    if (sharedFiles.isEmpty) return;

    try {

      final paths = sharedFiles.map((e) {
        // TODO: Handle null check for {e.value!}
        return FileHelper.filterFilePath(e.value!);
      }).toList();

      paths.removeWhere((value) => value.isEmpty);
      if (paths.isEmpty) return;

      filePaths = await FileHelper.saveToTempDirectory(paths);

      if (filePaths!.isEmpty) return;

      // Closing search page if already opened
      if (Get.currentRoute == Routes.customerJobSearch) {
        Get.back();
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }

      Get.toNamed(
        Routes.customerJobSearch,
        arguments: {
          NavigationParams.pageType: PageType.shareTo,
        },
        preventDuplicates: false,
      );
    } catch (e) {
      Get.back();
      Helper.showToastMessage(e.toString());
    }
  }

  static void clearData() {
    // resetting the intent to avoid opening search
    // page multiple times
    FlutterSharingIntent.instance.reset();
    filePaths?.clear();
  }
}
