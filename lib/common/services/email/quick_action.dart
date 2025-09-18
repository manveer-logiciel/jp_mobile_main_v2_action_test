import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/email_detail.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

class EmailService {
  
  static List<JPQuickActionModel> getQuickActionList() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: EmailDetailQuickActions.reply.toString(), child: const JPIcon(Icons.reply, size: 20), label: 'Reply'),
      JPQuickActionModel(id: EmailDetailQuickActions.replyAll.toString(), child: const JPIcon(Icons.reply_all, size: 20), label: 'Reply All'),
      JPQuickActionModel(id: EmailDetailQuickActions.forward.toString(), child: const JPIcon(Icons.forward_to_inbox, size: 20), label: 'Forward'),
      JPQuickActionModel(id: EmailDetailQuickActions.print.toString(), child: const JPIcon(Icons.print_outlined, size: 20), label: 'Print'),
    ];
  
    return quickActionList;
  }

  //Opening quick action bottom sheet
  static openQuickActions(EmailListingModel email, Function(int)? onEmailSent) {
    List<JPQuickActionModel> quickActionList = getQuickActionList();

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        onItemSelect: (value) {
          Get.back();
          handleQuickActions(value, email, onEmailSent);
        },
      ),
      isScrollControlled: false
    );
  }
   // Download email in pdf format for printing
   static printEmail(EmailListingModel email, {bool isRecursive = false}) async { 
    try {
      showJPLoader();
      String url = '${Urls.baseUrl}emails/${email.id}/pdf_print?download=1&recursive=${isRecursive ? 1 : 0}';
      DateTime convertedDate = DateTime.parse('${email.createdAt} Z');
      String fileName = '${convertedDate.microsecondsSinceEpoch}${email.id}.pdf';
      await DownloadService.downloadFile(url, fileName, action: 'print');
    } finally {
      Get.back();
    }
  }

  //Handling quick action tap
  static void handleQuickActions(String action, EmailListingModel email, Function(int)? onEmailSent) async {
    switch (action) {
      case 'EmailDetailQuickActions.print':
        printEmail(email);
        break;
      case 'EmailDetailQuickActions.reply':
        goToEmailCompose(email, 'reply', onEmailSent);
      break;
      case 'EmailDetailQuickActions.replyAll':
        goToEmailCompose(email, 'replyAll', onEmailSent);
      break;
      case 'EmailDetailQuickActions.forward':
        goToEmailCompose(email, 'forward', onEmailSent);
      break;
    }
  }

  static void goToEmailCompose(EmailListingModel email, String action, Function(int)? onEmailSent) async {
    dynamic arguments = {'email_id' : email.id, 'action': action};

    if(email.jobs != null && email.jobs!.isNotEmpty) {
      arguments['jobId'] = email.jobs![0].id;
      arguments[NavigationParams.customerId] = email.jobs![0].customerId;
    }
    final result = await Get.toNamed(Routes.composeEmail, arguments: arguments);

    if(result?['id'] != null) {
      onEmailSent?.call(result['id']);
    }
  }

   static String getHtmlData(String htmlFromApi){
      String  html = 
        '''<html lang="fr">
            <head>
              <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
              <style>
                body {
                  font-family: Roboto !important; 
                  font-size: 14px;
                  color: #666;
                }
                body.cke_editable.cke_editable_themed {
                  padding: 10px 0;
                }
                body.cke_editable {
                  font-size: 15px;
                }
                @media (min-width: 768px) {
                  body.cke_editable {
                    font-size: 19px;
                  }
                }

                body.placeholder {
                  color: #777;
                }

                body,
                h1,
                h2,
                h3,
                h4,
                h5,
                h6 {
                  color: #666;
                }
              
                .h1,
                .h2,
                .h3,
                .h4,
                .h5,
                .h6 {
                  color: #000;
                  font-weight: normal;
                  line-height: 1.2;
                }
                blockquote {
                  padding: 10px 20px;
                }
                blockquote p {
                  font-weight: 300;
                  font-size: 17.5px;
                  line-height: 1.25;
                }
                h1,
                h2,
                h3,
                h4,
                h5,
                input,
                p,
                select,
                span,
                textarea {
                  font-weight: normal;
                }

                .cke_editable {
                  font-size: 13px;
                  line-height: normal;
                  /* Fix for missing scrollbars with RTL texts. (#10488) */
                  word-wrap: break-word; 
                }

                .cke_editable > p {
                  margin: 0 0 10px;
                }

                blockquote {
                  font-style: italic;
                  font-family: Georgia, Times, "Times New Roman", serif;
                  padding: 2px 0;
                  border-style: solid;
                  border-color: #ccc;
                  border-width: 0;
                }

                .cke_contents_ltr blockquote {
                  padding-left: 20px;
                  padding-right: 8px;
                  border-left-width: 5px;
                }

                .cke_contents_rtl blockquote {
                  padding-left: 8px;
                  padding-right: 20px;
                  border-right-width: 5px;
                }

                a {
                  color: #0782c1;
                }

                ol,
                ul,
                dl {
                  padding: 0 40px;
                }

                h1,
                h2,
                h3,
                h4,
                h5,
                h6 {
                  font-weight: normal;
                  line-height: 1.2;
                }

                hr {
                  border: 0px;
                  border-top: 1px solid #ccc;
                }

                img.right {
                  border: 1px solid #ccc;
                  float: right;
                  margin-left: 15px;
                  padding: 5px;
                }

                img.left {
                  border: 1px solid #ccc;
                  float: left;
                  margin-right: 15px;
                  padding: 5px;
                }

                pre {
                  white-space: pre-wrap;
                  word-wrap: break-word;
                  -moz-tab-size: 4;
                  tab-size: 4;
                }

                .marker {
                  background-color: Yellow;
                }

                span[lang] {
                  font-style: italic;
                }

                figure {
                  text-align: center;
                  outline: solid 1px #ccc;
                  background: rgba(0, 0, 0, 0.05);
                  padding: 10px;
                  margin: 10px 20px;
                  display: inline-block;
                }

                figure > figcaption {
                  text-align: center;
                  display: block;
                }

                a > img {
                  padding: 1px;
                  margin: 1px;
                  border: none;
                }

                .code-featured {
                  border: 5px solid red;
                }

                .math-featured {
                  padding: 20px;
                  box-shadow: 0 0 2px rgba(200, 0, 0, 1);
                  background-color: rgba(255, 0, 0, 0.05);
                  margin: 10px;
                }

                .image-clean {
                  border: 0;
                  background: none;
                  padding: 0;
                }

                .image-clean > figcaption {
                  font-size: 0.9em;
                  text-align: right;
                }

                .image-grayscale {
                  background-color: white;
                  color: #666;
                }

                .image-grayscale img,
                img.image-grayscale {
                  filter: grayscale(100%);
                }

                .embed-240p {
                  max-width: 426px;
                  max-height: 240px;
                  margin: 0 auto;
                }

                .embed-360p {
                  max-width: 640px;
                  max-height: 360px;
                  margin: 0 auto;
                }

                .embed-480p {
                  max-width: 854px;
                  max-height: 480px;
                  margin: 0 auto;
                }

                .embed-720p {
                  max-width: 1280px;
                  max-height: 720px;
                  margin: 0 auto;
                }

                .embed-1080p {
                  max-width: 1920px;
                  max-height: 1080px;
                  margin: 0 auto;
                }

                body.cke_show_borders table.cke_show_border,
                body.cke_show_borders table.cke_show_border > tr > td,
                body.cke_show_borders table.cke_show_border > tr > th,
                body.cke_show_borders table.cke_show_border > tbody > tr > td,
                body.cke_show_borders table.cke_show_border > tbody > tr > th,
                body.cke_show_borders table.cke_show_border > thead > tr > td,
                body.cke_show_borders table.cke_show_border > thead > tr > th,
                body.cke_show_borders table.cke_show_border > tfoot > tr > td,
                body.cke_show_borders table.cke_show_border > tfoot > tr > th {
                  border: 0;
                }
                body.cke_editable {
                  margin: 0;
                  padding: 15px;
                }
                .cke_editable.cke_table-faked-selection-editor:focus .cke_table-faked-selection,
                .cke_table-faked-selection-editor .cke_table-faked-selection {
                  background: transparent !important;
                  color: #333;
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
                  elementForScale[0].style.fontSize =  '50px !important;';
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
}