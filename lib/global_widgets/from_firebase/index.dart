import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/global_widgets/from_firebase/controller.dart';

class FromFirebase extends GetView<FromFirebaseController> {

  const FromFirebase(
      {Key? key,
      required this.child,
      this.realTimeKeys,
      this.placeholder,
      this.fireStoreKeyType,
      this.result = RealTimeResult.firstValue,
      this.sumResultKeys,
      })
      : super(key: key);

  final Widget Function(dynamic value) child;

  final List<RealTimeKeyType>? realTimeKeys;

  final FireStoreKeyType? fireStoreKeyType;

  final Widget? placeholder;

  final RealTimeResult result;

  final List<dynamic>? sumResultKeys;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FromFirebaseController>(
      builder: (controller) {

        final val = sumResultKeys == null
            ? controller.getValues(keys: realTimeKeys, result: result, fireStoreKeyType: fireStoreKeyType)
            : controller.getAddedResult(sumResultKeys!);

        return val == null && val != 0
            ? placeholder ?? const SizedBox()
            : child(val);
      }
    );
  }
}
