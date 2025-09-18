import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomerFormSyncWithQB extends StatelessWidget {
  const CustomerFormSyncWithQB({
    super.key,
    required this.service,
    this.isDisabled = false
  });

  final CustomerFormService service;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Row(
        children: [
          Expanded(
            child: JPText(
              text: QuickBookService.isQBDConnected() ? "sync_with_qb_desktop".tr : "sync_with_qb_online".tr,
              fontWeight: JPFontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ),
          JPToggle(
              disabled: isDisabled,
              value: service.syncWithQBDesktop,
              onToggle: service.toggleSyncWithQBDesktop,
          )
        ],
      ),
    );
  }
}
