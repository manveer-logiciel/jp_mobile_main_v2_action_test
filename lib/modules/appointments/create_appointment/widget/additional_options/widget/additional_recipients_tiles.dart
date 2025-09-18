import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AdditionalRecipientsSuggestionListTile extends StatelessWidget {
   const AdditionalRecipientsSuggestionListTile({
    super.key, this.profile, required this.state, required this.controller, required this.actionFrom,
  });

  final dynamic profile;
  final JPChipsInputState<Object?> state;
  final CreateAppointmentFormController controller;
  final String actionFrom;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ((){
        state.selectSuggestion(profile);
        controller.addEmailInList(profile);
      }),
      child: Container(
        key: ObjectKey(profile),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 15, top: 18, bottom: 10),
              child: JPProfileImage(
                size: JPAvatarSize.small,
                src: profile.imageUrl,
                initial: profile.initial,
                color: profile.color,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 12,bottom: 12),
                decoration:  BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: JPAppTheme.themeColors.inverse),
                  ),
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text: profile.name,
                      fontWeight: JPFontWeight.medium),
                    const SizedBox(height: 5),
                    JPText(
                      text: profile.email,
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.tertiary,
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}