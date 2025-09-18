import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPPhoneBookDialog extends StatelessWidget {
  const JPPhoneBookDialog({
    super.key,
    required this.phoneNumbers,
    required this.callback
  });

  final List<PhoneModel> phoneNumbers;
  final Function(PhoneModel) callback;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(
                    text: "choose_number".tr.toUpperCase(),
                    textSize: JPTextSize.heading3,
                    fontWeight: JPFontWeight.medium,
                  ),
                  JPTextButton(
                    onPressed: () => Get.back(),
                    color: JPAppTheme.themeColors.text,
                    icon: Icons.clear,
                    iconSize: 24,
                  )
                ],
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                separatorBuilder: (_, __) => Divider(height: 1, thickness: 1, color: JPAppTheme.themeColors.dimGray),
                itemCount: phoneNumbers.length,
                itemBuilder: (_, index) {
                  final data = phoneNumbers[index];
                  return InkWell(
                    onTap: (){
                      callback.call(data);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top:  index == 0 ? 10 : 18,
                        left: 0,
                        right: 10,
                        bottom: 10
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: JPText(
                              text: data.label?.capitalizeFirst ?? '',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: JPText(
                              text: data.number ?? '',
                              textAlign: TextAlign.start
                            ),
                          )
                          ,
                        ],
                      ),
                    )
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}