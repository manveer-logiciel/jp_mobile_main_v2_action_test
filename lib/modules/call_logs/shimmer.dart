import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class CallLogShimmer extends StatelessWidget {
  const CallLogShimmer({ super.key });

  @override
  Widget build(BuildContext context) {

    Widget getJobTile(int index){
      return Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1,color: JPAppTheme.themeColors.inverse))
              ),
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),                   
                    color: JPAppTheme.themeColors.darkGray,
                    )
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          width: MediaQuery.of(context).size.width-120,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                        ),
                        Container(
                          margin : const EdgeInsets.only(bottom: 12),
                          width: MediaQuery.of(context).size.width-120,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          width: MediaQuery.of(context).size.width-120,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top : 8.0),
                          child: Row(children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              width: 100,
                              height: 10,
                              color :JPAppTheme.themeColors.dimGray,
                              ),
                              const Spacer(),
                              Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: JPAppTheme.themeColors.darkGray,
                              )
                              ),
                            ]),
                        )
                       ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
          );
    }
    
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.40,
      ),
      child:ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index)=>Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor:JPAppTheme.themeColors.inverse,
          child: getJobTile(index))
           ))
         );
 
  }
}