import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OptedOutDialogBox extends StatelessWidget {
  const OptedOutDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('receipt_has_opted_out'.tr),
      content: Text(
        'opted_out_message'.tr,
      ),
      actions: [
         CupertinoDialogAction(
            child: Text("ok".tr.toUpperCase()),
            onPressed: () {
              Get.back();
            },),
      ],
    );
  }
}