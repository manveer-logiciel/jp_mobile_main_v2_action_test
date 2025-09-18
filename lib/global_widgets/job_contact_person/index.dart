import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/job_contact_person/contact_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobContactPerson extends StatelessWidget {
  const JobContactPerson({
    super.key,
    required this.job,
    this.overflow = TextOverflow.ellipsis, 
    this.updateScreen,
  });

  final JobModel job;
  final TextOverflow? overflow;
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: JPText(
              text: "contact_person".tr.toUpperCase(),
              textAlign: TextAlign.start,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
              fontWeight: JPFontWeight.medium,
            ),
          ),
          for ( int index = 0; index < (job.contactPerson?.length ?? 0); index++ )
            JobContactPersonTile(
              updateScreen: updateScreen,
              contactPerson: job.contactPerson![index],
              job: job,
              overflow: overflow,
            )
        ],
      ),
    );
  }
}