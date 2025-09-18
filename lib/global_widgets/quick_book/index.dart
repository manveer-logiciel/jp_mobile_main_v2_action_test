import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/quick_book.dart';

class QuickBookIcon extends StatelessWidget {

  const QuickBookIcon({super.key,
    this.status,
    this.origin, 
    this.isSyncDisable,
    this.quickbookId,
    this.qbDesktopId,
    this.ghostJob,
    this.height = 24,
    this.width = 24,
  });

  final String? status;
  final String? origin;
  final int? isSyncDisable;
  final String? quickbookId;
  final String? qbDesktopId;
  final String? ghostJob;
  final double? height;
  final double? width;

  String? getPath() {
    
      String statusIcon = 'assets/images/qb/qb-no-synced.png';
      bool isQBConnected = QuickBookService.isQuickBookConnected();
      bool isQBDConnected = QuickBookService.isQBDConnected();

      if (status == '0') {

        statusIcon = 'assets/images/qb/qb-process.png';

      } else if (status == '2') {
        
        statusIcon = 'assets/images/qb/qb-warning.png';

      } else if (ghostJob == '1') {
      
        statusIcon = 'assets/images/qb/qb-ghost.png';

      } else if (isQBConnected) {
     
        if (status == '1' || quickbookId != null) {

          if (origin == "JobProgress" || origin == "QuickBookDesktop"){  

            statusIcon = 'assets/images/qb/jp-qb.png';

          } else if (origin == "QuickBooks") {
            
            statusIcon = 'assets/images/qb/qb-jp.png';

          } else if (origin != "JobProgress" && origin != "QuickBooks" && origin != "QuickBookDesktop"){  

            statusIcon = 'assets/images/qb/qb.png';

          }
        }
        } else if (isQBDConnected) {
       
        if (status == '1' || qbDesktopId != null) {
        
          if ( origin == "JobProgress" || origin == "QuickBooks"){

              statusIcon = 'assets/images/qb/jp-qb.png';

          } else if (origin == "QuickBookDesktop") {
            
            statusIcon = 'assets/images/qb/qb-jp.png';

          } else if (origin != "JobProgress" && origin != "QuickBooks" && origin != "QuickBookDesktop"){
            
            statusIcon = 'assets/images/qb/qb.png';
            
          }
        }
      }

    if ((!isQBConnected && !isQBDConnected) || isSyncDisable == 1) {
       return null;
    }

    return statusIcon;
  }

  
  Widget getChild(){
    return getPath() != null ? Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Image.asset(getPath()!, height: height, width: width),
    ) : const SizedBox.shrink();
  }  

  @override
  Widget build(BuildContext context) {
  
  
  return SizedBox(
    child: getChild()
  );
}
}