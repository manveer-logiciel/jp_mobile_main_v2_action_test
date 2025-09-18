import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/quick_book_sync_error/index.dart';

class QuickBookService {
  
  static bool isQuickBookConnected () {
    dynamic qb = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.quickbook);
    bool isQBConnected = qb != null && qb[ConnectedThirdPartyConstants.quickbookCompanyId] != null && qb[ConnectedThirdPartyConstants.quickbookCompanyId].toString().isNotEmpty;
    return isQBConnected;
  }

  static bool isQBDConnected () {
    dynamic isQBConnected = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.quickbookDesktop);
    return isQBConnected ?? false;
  }
  
  static 
  openQuickBookErrorBottomSheet(String entity, String entityId){
    return  showJPBottomSheet(
      isScrollControlled: true,
      child: ((_) {
        return  QuickBookSyncError(entity: entity, entityId: entityId);
      })
    );
  }

  static String getHtmlData(String htmlFromApi){
    String  html = 
      '''<html lang="fr">
            <head>
              <style>
                @font-face {
                  font-family: "Roboto-Regular";
                  src: url("../fonts/Roboto-Regular.ttf") format("truetype");
                  font-weight: normal;
                  font-style: normal;
                }
                * {
                  color:#666;
                  margin:0;
                  -webkit-touch-callout: none;
                  -webkit-user-select: none;
                  user-select: none;
                } 
                body {
                  font-family: Roboto-Regular;
                  font-size: 14px;
                  color: #666;
                }
                ol,ul {
                  padding-inline-start: 15px;
                }
                ol li, ul li {
                  margin-bottom: 10px;
                }
              </style>
            </head>
            <body>
              <div class="container"  id="_flutter_target_do_not_delete">$htmlFromApi</div>
              <script>
              function outputsize() {
                if (typeof window.flutter_inappwebview !== "undefined" && typeof window.flutter_inappwebview.callHandler !== "undefined") {
                  setHeight()
                  setScale();                  
                }
              }
              function setHeight() {
                var elementForHeight = document.getElementsByClassName("container");
                elementForHeight[0].style.height = 'auto';
                var height = elementForHeight[0].offsetHeight;
                //Getting actual height after scaling
                if(elementForHeight[0].getBoundingClientRect) {
                  height = elementForHeight[0].getBoundingClientRect().height;
                  elementForHeight[0].style.height = height;
                }
                window.flutter_inappwebview.callHandler('setHeight', height);
              }
              function setScale() {
                var elementForScale = document.getElementsByClassName("container");
                
                elementForScale[0].style.width = 'auto'
                var elementWidth = elementForScale[0].offsetWidth;
                elementForScale[0].style.width = 'fit-content'
                var maxWidthOfTemplate = elementForScale[0].offsetWidth;
                
                var scale = elementWidth / maxWidthOfTemplate;
                if(maxWidthOfTemplate >= elementWidth && scale < 1) {
                  elementForScale[0].style.transform = "scale(" + scale + ")";
                  elementForScale[0].style.transformOrigin = 'left top';
                  elementForScale[0].style.fontSize =  (10 / scale) + 'px !important;';
                } else {
                  elementForScale[0].style.width = 'auto'
                }
              }
              
              setTimeout(function() {
                new ResizeObserver(outputsize).observe(_flutter_target_do_not_delete)
                var tags = document.getElementsByTagName("a");
                
                for (let index = 0; index < tags.length; index++) {
                  var aTag = tags[index];
                  var link = aTag.getAttribute("href");
                  aTag.setAttribute("target", link);
                  aTag.removeAttribute("href");
                  aTag.addEventListener('click', event => {
                    window.flutter_inappwebview.callHandler('handle_link', event.target.target);
                  })
                }
              }, 150);
              </script>
            </body>
          </html>''';
    return html;
  }

  static String? getQDBStatus (WorksheetModel? worksheet) {

    if ((worksheet?.isQbdWorksheet ?? false) && !(worksheet?.isSyncOnQbd ?? true)){
      return "qbd_enabled".tr;
    } else {
      return null;
    }
    ///   TODO - FileListing (QBD Status) - Didn't got date model
    /*if (!qbd_queue_status) {
      return "QBD In Queue";
    }

    switch (qbd_queue_status.status) {
      case "q":
        return "QBD In Queue";
      case "s":
        return "QBD Synced";
      case "i":
        return "QBD In Process";
      case "e":
        return "QBD Not Synced";
      case "n":
        return "QBD";
    }*/
  }
}