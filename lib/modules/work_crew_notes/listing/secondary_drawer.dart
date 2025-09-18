import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class WorkCrewNotesSecondaryHeader extends StatelessWidget {

  final WorkCrewNotesListingController workCrewNoteController;

  const WorkCrewNotesSecondaryHeader({super.key, required this.workCrewNoteController});

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.only(top : 10, left: 16, bottom: 10, right: 16),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [           
      JPText(
        text: 'work_crew_notes'.tr.toUpperCase() + (workCrewNoteController.workCrewListOfTotalLength == 0 ? '' : ' (${workCrewNoteController.workCrewListOfTotalLength})'),
        fontWeight: JPFontWeight.medium,
        textSize: JPTextSize.heading4
      ),
      InkWell(
        onTap: () {
          workCrewNoteController.sortWorkCrewNoteListing();
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: workCrewNoteController.paramkeys.sortOrder == 'desc' ? SvgPicture.asset('assets/svg/sort_asc.svg') : SvgPicture.asset('assets/svg/sort_desc.svg'),
        )
       )
      ],
     ),
       );
  }
}
