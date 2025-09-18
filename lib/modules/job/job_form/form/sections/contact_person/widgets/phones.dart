
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormContactPersonPhones extends StatelessWidget {
  const JobFormContactPersonPhones({
    super.key,
    this.phones
  });

  final List<PhoneModel>? phones;

  @override
  Widget build(BuildContext context) {

    if (phones == null) return const SizedBox();

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, index) {

        final phone = phones![index];

        return Row(
          children: [
            JPText(
              text: PhoneMasking.maskPhoneNumber(phone.number ?? ""),
            ),

            const SizedBox(width: 10,),

            if (phone.ext?.isNotEmpty ?? false) ...{
              JPText(
                text: 'ext'.tr,
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              const SizedBox(width: 2,),
              JPText(
                text: phone.ext!,
              ),
            }
          ],
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: phones!.length,
    );
  }
}
