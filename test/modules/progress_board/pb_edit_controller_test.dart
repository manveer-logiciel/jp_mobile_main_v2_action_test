import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/progressboard_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/progress_board/production_board_column.dart';
import 'package:jobprogress/common/models/progress_board/progress_board_moadel.dart';
import 'package:jobprogress/modules/progress_board/controller.dart';
import 'package:jobprogress/modules/progress_board/widget/edit_pb_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final pbController = ProgressBoardController();

  Map<String, dynamic> pbJson = {
    "data":[
      {
        "id":425,
        "name":"new"
      },
      {
        "id":656,
        "name":"Mayank"
      },
      {
        "id":679,
        "name":"tajinder"
      },
      {
        "id":680,
        "name":"Ra-One PB"
      },
      {
        "id":719,
        "name":"cxvcxvcx"
      },
      {
        "id":732,
        "name":"Progress board 1"
      },
      {
        "id":733,
        "name":"Progress board 2"
      },
      {
        "id":774,
        "name":"test"
      },
      {
        "id":775,
        "name":"test3"
      },
      {
        "id":804,
        "name":"PB Workflow 1"
      },
      {
        "id":805,
        "name":"board 1"
      },
      {
        "id":806,
        "name":"board 2"
      },
      {
        "id":814,
        "name":"Sankhush"
      },
      {
        "id":815,
        "name":"Sankhush1"
      },
      {
        "id":817,
        "name":"XYZ"
      },
      {
        "id":818,
        "name":"merge"
      },
      {
        "id":820,
        "name":"pb123"
      },
      {
        "id":821,
        "name":"hh"
      },
      {
        "id":831,
        "name":"Treet"
      },
      {
        "id":926,
        "name":"kunal"
      },
      {
        "id":1282,
        "name":"mir"
      },
      {
        "id":1290,
        "name":"Sukhman"
      },
      {
        "id":1321,
        "name":"Test"
      },
      {
        "id":1322,
        "name":"East"
      },
      {
        "id":1345,
        "name":"Teena"
      }
    ],
  };

  Map<String, dynamic> columnsJson = {
    "data":[
      {
        "id":3379,
        "name":"Deccan",
        "board_id":425,
        "sort_order":1
      },
      {
        "id":3380,
        "name":"Deccan R",
        "board_id":425,
        "sort_order":2
      },
      {
        "id":3381,
        "name":"L Phillips",
        "board_id":425,
        "sort_order":3
      },
      {
        "id":3799,
        "name":"column tests",
        "board_id":425,
        "sort_order":4
      }
    ],
  };

  Map<String, dynamic> jobJson = {
    "data":[
      {
        "id":12883,
        "number":"2105-9601-06",
        "trades":[
          {
            "id":35,
            "name":"PROPERTY MANAGEMENT",
          }
        ],
        "work_types":[
          {
            "id":745,
            "trade_id":35,
            "name":"Square Ft",
            "type":2,
            "order":0,
            "color":"#9C2542",
            "deleted_at":null,
            "qb_id":"55",
            "qb_account_id":"207",
          }
        ],
        "archived":null,
        "order":20,
        "job_archived":null,
        "multi_job":0,
        "customer":{
          "id":9601,
          "full_name":"Data Test",
          "company_name":"Test",
          "email":"af@gmail.com",
          "origin":"JobProgress",
          "address":{
            "id":18028,
            "address":"",
            "address_line_1":"",
            "city":"",
            "state_id":0,
            "state":null,
            "country_id":1,
            "country":{
              "id":1,
              "name":"United States",
              "code":"US",
              "currency_name":"Doller",
              "currency_symbol":"\$",
              "phone_code":"+91"
            },
            "zip":null,
            "lat":null,
            "long":null,
            "geocoding_error":1,
            "created_by":null,
            "updated_by":null,
            "update_origin":null,
            "updated_from":null,
            "device_uuid":null
          }
        },
        "pb_entries":{
          "data":[
            {
              "id":654,
              "column_id":3380,
              "data":"{\"type\":\"markAsDone\",\"value\":\"1\"}",
              "color":"",
              "productionBoardColumn":{
                "id":3380,
                "name":"Deccan R",
                "board_id":425,
                "default":false,
                "sort_order":2,
              },
              "task":{
                "id":9410,
                "title":"Test Buddy",
                "notes":"test",
                "due_date":"2022-10-19",
                "job_id":12883,
                "stage_code":"23193140",
                "completed":null,
                "is_high_priority_task":0,
                "locked":1,
                "reminder_type":null,
                "reminder_frequency":null,
                "is_due_date_reminder":0,
                "is_wf_task":0,
                "send_as_message":0,
                "created_by":1,
                "participants":{
                  "data":[
                    {
                      "id":4289,
                      "first_name":"Aaron",
                      "last_name":"Kulas",
                      "full_name":"Aaron Kulas",
                      "full_name_mobile":"Aaron Kulas",
                      "email":"Standuser2948@yopmail.com",
                      "group_id":3,
                      "profile_pic":"https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F1_1630133071.jpg",
                      "color":null,
                      "company_name":"",
                      "total_commission":null,
                      "paid_commission":null,
                      "unpaid_commission":null,
                      "all_divisions_access":false,
                      "status":null
                    }
                  ]
                },
                "notify_users":{
                  "data":[
                    {
                      "id":4637,
                      "first_name":"Abagail",
                      "last_name":"Wilderman",
                      "full_name":"Abagail Wilderman",
                      "full_name_mobile":"Abagail Wilderman",
                      "email":"Standuser6649@yopmail.com",
                      "group_id":3,
                      "profile_pic":"https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F1_1630133071.jpg",
                      "color":null,
                      "company_name":"",
                      "total_commission":null,
                      "paid_commission":null,
                      "unpaid_commission":null,
                      "all_divisions_access":false,
                      "status":null
                    }
                  ]
                },
              }
            },
            {
              "id":655,
              "column_id":3379,
              "data":"{\"type\":\"input_field\",\"value\":\"text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text\"}",
              "color":"#CCF2FF",
              "productionBoardColumn":{
                "id":3379,
                "name":"Deccan",
                "board_id":425,
                "default":false,
                "sort_order":1,
                "created_at":"2021-01-27 11:13:27",
                "updated_at":"2021-01-27 11:13:27"
              }
            },
            {
              "id":659,
              "column_id":3799,
              "data":"{\"type\":\"input_field\",\"value\":\"ffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsd f fsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdff sdfsdffs fsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdff sdfsdffsdfsdffsdfsdffsdfsdffsdf sdffsdfsdffsdfs dffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsd ffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdffsdfsdf\"}",
              "color":"#E6FFE6",
              "productionBoardColumn":{
                "id":3799,
                "name":"column tests",
                "board_id":425,
                "default":false,
                "sort_order":4
              },
              "task":{
                "id":6038,
                "title":"Dsa",
                "notes":null,
                "due_date":null,
                "job_id":12883,
                "stage_code":"23193140",
                "completed":null,
                "is_high_priority_task":0,
                "locked":0,
                "reminder_type":null,
                "reminder_frequency":null,
                "is_due_date_reminder":0,
                "is_wf_task":0,
                "send_as_message":0,
                "created_by":1,
                "participants":{
                  "data":[
                    {
                      "id":1,
                      "first_name":"Rahul",
                      "last_name":"(Admin 1)",
                      "full_name":"Rahul (Admin 1)",
                      "full_name_mobile":"Rahul (Admin 1)",
                      "email":"rahul@logiciel.io",
                      "group_id":5,
                      "profile_pic":"https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F1_1664373109.jpg",
                      "color":"#1c36ee",
                      "company_name":"",
                      "total_commission":null,
                      "paid_commission":null,
                      "unpaid_commission":null,
                      "all_divisions_access":true,
                      "status":null
                    }
                  ]
                },
                "notify_users":{
                  "data":[
                    {
                      "id":1,
                      "first_name":"Rahul",
                      "last_name":"(Admin 1)",
                      "full_name":"Rahul (Admin 1)",
                      "full_name_mobile":"Rahul (Admin 1)",
                      "email":"rahul@logiciel.io",
                      "group_id":5,
                      "profile_pic":"https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F1_1664373109.jpg",
                      "color":"#1c36ee",
                      "company_name":"",
                      "total_commission":null,
                      "paid_commission":null,
                      "unpaid_commission":null,
                      "all_divisions_access":true,
                      "status":null
                    }
                  ]
                },
              }
            },
            {
              "id":660,
              "column_id":3381,
              "data":"{\"type\":\"input_field\",\"value\":\"dfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf. \\ngdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf. gdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf\\ngdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf\\ngdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfg\\ndfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf\"}",
              "color":null,
              "productionBoardColumn":{
                "id":3381,
                "name":"L Phillips",
                "board_id":425,
                "default":false,
                "sort_order":3
              }
            }
          ]
        },
        "address":{
          "id":18028,
          "address":"",
          "address_line_1":"",
          "city":"",
          "state_id":0,
          "state":null,
          "country_id":1,
          "country":{
            "id":1,
            "name":"United States",
            "code":"US",
            "currency_name":"Doller",
            "currency_symbol":"\$",
            "phone_code":"+91"
          },
          "zip":null,
          "lat":null,
          "long":null,
          "geocoding_error":1,
          "created_by":null,
          "updated_by":null,
          "update_origin":null,
          "updated_from":null,
          "device_uuid":null
        },
        "current_stage":{
          "name":"Paid",
          "color":"cl-skyblue",
          "code":"23193140",
          "resource_id":17
        },
      }
    ],
  };

  Map<String, dynamic> colorJson = {
    "data":[
      "#F0F8FF",
      "#FFE6E6",
      "#FFF0F5",
      "#E6E6FF",
      "#E6FFE6",
      "#FFFFCC",
      "#EBEBE0",
      "#F2F2F2",
      "#FFECB3",
      "#CCF2FF",
      "#B3FFB3"
    ]
  };

  late EditPBDialogController controller;

  void setUpAll() {
    ///   Set Progress board List
    List<ProgressBoardModel> list = [];
    pbJson["data"].forEach((dynamic board) => list.add(ProgressBoardModel.fromJson(board)));
    pbController.pbList = [];
    for (var pbItem in list) {
      pbController.pbList.add(JPSingleSelectModel(id: pbItem.id!.toString(), label: pbItem.name!.capitalize!));
    }
    ///   Set Column List
    pbController.tabList = [];
    columnsJson["data"].forEach((dynamic column) => pbController.tabList.add(ProductionBoardColumn.fromJson(column)));
    ///   Set Board List
    pbController.boardList = [];
    jobJson["data"].forEach((dynamic board) => pbController.boardList.add(JobModel.fromProgressBoardJson(board)));
    pbController.boardList = pbController.sortPBEntries(pbController.boardList);
    ///   Set Color List
    pbController.colorList = [];
    colorJson["data"].forEach((dynamic color) => pbController.colorList.add(color));
    ///   Set Controller
    controller = EditPBDialogController(
        jobModel: pbController.boardList[0],
        rowIndex: 0,
        columnIndex: 0,
        colorList: pbController.colorList,
        columnId: pbController.boardList[0].pbEntries![0]!.id
    );
  }

  group('Initialising data for edit progress board', () {
    setUpAll();

    test('EditPBDialogController@initData should load initial data', () {
      controller.initData();
      expect(controller.selectedColor, "#CCF2FF");
      expect(controller.radioGroup, PBChooseOptionKey.addNote);
      expect(controller.noteTextController.text.isNotEmpty, true);
    });

    test('EditPBDialogController@updateRadioValue should update selected radiobutton', () {
      controller.updateRadioValue(PBChooseOptionKey.none);
      expect(controller.radioGroup, PBChooseOptionKey.none);
    });

    test('EditPBDialogController@updateColorSelection should update selected color', () {
      controller.updateColorSelection(pbController.colorList[4]);
      expect(controller.selectedColor, "#E6FFE6");
    });

    test('EditPBDialogController@resetSelectedColor should reset selected color', () {
      controller.resetSelectedColor();
      expect(controller.selectedColor, "");
    });

    test('EditPBDialogController@resetSelectedColor should reset selected color', () {
      controller.resetSelectedColor();
      expect(controller.selectedColor, "");
    });

  });
}