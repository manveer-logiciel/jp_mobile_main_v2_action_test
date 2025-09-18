import 'common/meta_mock_response.dart';

class EmailTemplateMockResponse {

  static Map<String,dynamic> okResponse = {
    "data":[
      {
        "id":5963,
        "title":"Shingle Color",
        "template":"<p style='' 'box-sizing':'border-box; outline':'none !important; margin':'0px 0px 10px; font-weight':'normal;''>Good morning/afternoon,</p><p style='' 'box-sizing':'border-box; outline':'none !important; margin':'0px 0px 10px; font-weight':'normal;''>Thank you for sending the signed proposal over, we are veryexcited to get started on your project! Before work can begin, we need toconfirm the following:</p><ul style='' 'box-sizing':'border-box; outline':'none!important; margin-top':'0px; margin-bottom':10px;'><li style='' 'box-sizing':'border-box; outline':'none !important;''>SHINGLE COLOR</li></ul><p style='' 'box-sizing':'border-box; outline':'none !important; margin':'0px 0px 10px; font-weight':'normal;''>If you would like to browse shingle colors available inyour area, please<span>&nbsp;</span><a href='https:' style='' 'box-sizing':'border-box; outline':'none !important; background':'0px 0px; color':rgb(66,139,'202); text-decoration':'none; font-weight':'normal; cursor':'pointer;'' target=''_blank''>click here</a>. Once you have chosen, please reply to this email with your color and let me know if you have any questions!</p>",
        "active":1,
        "subject":"Goody - Shingle Color",
        "send_to_customer":false,
        "recipients_setting":{
          "to":<Null>[],
          "cc":<Null>[],
          "bcc":<Null>[]
        },
        "new_format":0,
        "price":null,
        "type":null,
        "to":{
          "data":<Null>[]
        },
        "cc":{
          "data":<Null>[]
        },
        "bcc":{
          "data":<Null>[]
        },
        "attachments":{
          "data":<Null>[]
        }
      }
    ],
    "meta": MetaMockResponse.valueWithCount(1),
    "status":200
  };
}