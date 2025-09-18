import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialNoteTile extends StatelessWidget {
  const JobFinancialNoteTile({super.key, required this.controller});
  final JobFinancialController controller;
  
  @override
  Widget build(BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
          child: Material(
            color: JPAppTheme.themeColors.base,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: controller.isNoteEnable()? controller.openEditNote: null,
              borderRadius: BorderRadius.circular(18), 
              child: Container(
              padding: const EdgeInsets.all(20),  
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 0),
                      child: JPText(
                        text: 'note'.tr.toUpperCase(), 
                        textColor: JPAppTheme.themeColors.darkGray,
                        fontWeight: JPFontWeight.medium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: 
                        Row(
                        children: [
                          if(controller.note.isEmpty)... {
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: JPText(
                                text: 'tap_here'.tr ,
                                textColor: JPAppTheme.themeColors.primary,
                              ),
                            ),
                            JPText(text: ' ${'to_create_a_note'.tr}', textColor: JPAppTheme.themeColors.darkGray),
                          } else... {
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: JPText(
                                  text: controller.note,
                                  textAlign: TextAlign.left, 
                                  textColor: JPAppTheme.themeColors.text,
                                ),
                              ) 
                            )
                          }       
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
     
  }
}
