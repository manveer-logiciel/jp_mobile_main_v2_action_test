import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/has_permission/controller.dart';

class HasPermission extends StatelessWidget {
  final Widget child;
  // if You want to HasPermission give opposite result
  final bool reverse; 
  final List<String> permissions;
  final bool isAllPermissionRequired;
  final bool forSubcontractor;
  final bool orOtherCondition;
  
  const HasPermission({
    required this.child,
    required this.permissions,
    this.reverse = false,
    this.isAllPermissionRequired = false,
    this.forSubcontractor = false,
    super.key, this.orOtherCondition = false
  });

 @override
  Widget build(BuildContext context) {

    if(!Get.isRegistered<HasPermissionController>()) {
      Get.put(HasPermissionController());
    }

    final hasPermissionController = Get.find<HasPermissionController>();

    return GetBuilder<HasPermissionController>(
      builder: (_) {
        if(reverse){
          if(
            !(hasPermissionController.hasUserPermissions(
              permissions,
              isAllRequired: isAllPermissionRequired,
              forSubcontractor: forSubcontractor && orOtherCondition)
            )) {
              return child;
          } else { 
            return const SizedBox.shrink();
          }
         
        } else { 
          if(hasPermissionController.hasUserPermissions(
            permissions,
            isAllRequired: isAllPermissionRequired,
            forSubcontractor: forSubcontractor) || 
            orOtherCondition) {
              return child;
          } else { 
              return const SizedBox.shrink();
          }
        }
      }
    );
  }
}