import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class NoteListingShimmmer extends StatelessWidget {  
  final NoteListingType type;
  
  const NoteListingShimmmer({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
        
    Widget showProfile(){
      return Padding(                
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          height: type == NoteListingType.workCrewNote ? 30 : 36,
          width: type == NoteListingType.workCrewNote ? 30 : 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(type == NoteListingType.workCrewNote ? 8 : 50),
            color: JPAppTheme.themeColors.inverse,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 11,
        padding: const EdgeInsets.only(left: 16, top: 10),
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showProfile(),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10, top: 12, right: 16),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 8,
                                width: MediaQuery.of(context).size.width -90,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 8,
                                width: MediaQuery.of(context).size.width -90,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 8,
                                width: MediaQuery.of(context).size.width -90,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 5,
                                width: 100,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  

                ],
              ));
        },
      ),
    );
  }
}
