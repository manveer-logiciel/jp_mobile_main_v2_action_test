import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class NotesShimmer extends StatelessWidget {
  const NotesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: JPAppTheme.themeColors.base),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width*0.3,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: JPAppTheme.themeColors.dimGray,
                        ),

                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  ListView.builder(
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) { 
                      return Column(
                        children: [
                          Container(
                            height: 14,
                            width: MediaQuery.of(context).size.width,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 14,
                            width: MediaQuery.of(context).size.width,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                          const Divider(
                            height: 20,
                          ),
                        ],
                      );
                    },
                    
                  )
                  
                ],
              ),
            ),
          )
      ),
    );
  }
}


