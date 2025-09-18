import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/progress_board/production_board_column.dart';
import 'package:jobprogress/common/models/progress_board/progress_board_moadel.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/modules/progress_board/controller.dart';
import 'package:jobprogress/modules/progress_board/reordering_job_listing/controller.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ProgressBoardController();

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

  List<String> permissionList = [
    "export_customers",
    "manage_progress_board",
  ];

  group('Initialising data for progress board', () {
    List<ProgressBoardModel> pbList = [];
    pbJson["data"].forEach((dynamic board) => pbList.add(ProgressBoardModel.fromJson(board)));
    controller.filterKeys.boardId ??= pbList.first.id;
    controller.fetchJobProgressBoard();

    test('ProgressBoardController@fetchProgressBoardList should load list of available progress boards', () {
      controller.fetchProgressBoardList();
      expect(controller.isLoading, true);
      expect(controller.filterKeys.progressBardListToJson()["limit"], 0);
    });

    test('ProgressBoardController@fetchProgressBoardColumns should load progress board column data', () {
      var params = controller.filterKeys.progressBardColumnsToJson();
      expect(controller.isLoading, true);
      expect(params["limit"], 0);
      expect(params["board_id"], 425);
    });

    test('ProgressBoardController@fetchJobProgressBoard should load progress board data', () {
      var params = controller.filterKeys.toJson();
      expect(controller.isLoading, true);
      expect(params["limit"], 20);
      expect(params["page"], 1);
      expect(params["sort_by"], "order");
      expect(params["sort_order"], "asc");
      expect(params["board_id"], 425);
      expect(params["job_number"], null);
      expect(params["job_alt_id"], null);
      expect(params["job_address"], null);
      expect(params["job_zip_code"], null);
      expect(params["trade_id"], null);
    });

    test('ProgressBoardController@fetchColorList should load progress_board colors', () {
      controller.fetchColorList();
      var params = controller.filterKeys.progressBardColorJson();
      expect(controller.isLoading, true);
      expect(params["type"], "progress_board");
    });

    test('ProgressBoardController@refreshList should reset page count and reload data', () {
      controller.refreshList();
      var params = controller.filterKeys.toJson();
      expect(controller.isLoading, false);
      expect(params["limit"], 20);
      expect(params["page"], 1);
      expect(params["sort_by"], "order");
      expect(params["sort_order"], "asc");
      expect(params["board_id"], 425);
      expect(params["job_number"], null);
      expect(params["job_alt_id"], null);
      expect(params["job_address"], null);
      expect(params["job_zip_code"], null);
      expect(params["trade_id"], null);
    });

    test('ProgressBoardController@loadMore should increase page count and load more data', () {
      int currentPage = controller.filterKeys.page;

      controller.loadMore();
      var params = controller.filterKeys.toJson();
      expect(controller.isLoading, false);
      expect(params["limit"], 20);
      expect(params["page"], ++currentPage);
      expect(params["sort_by"], "order");
      expect(params["sort_order"], "asc");
      expect(params["board_id"], 425);
      expect(params["job_number"], null);
      expect(params["job_alt_id"], null);
      expect(params["job_address"], null);
      expect(params["job_zip_code"], null);
      expect(params["trade_id"], null);
    });

  });

  group('For progress board Ui manipulation', () {

    test('ProgressBoardController@sortPBEntries should sort pbEntries list according to column List', () {
      controller.tabList = [];
      columnsJson["data"].forEach((dynamic board) => controller.tabList.add(ProductionBoardColumn.fromJson(board)));

      controller.boardList = [];
      jobJson["data"].forEach((dynamic board) => controller.boardList.add(JobModel.fromProgressBoardJson(board)));

      List<JobModel> newBoardList = controller.sortPBEntries(controller.boardList);
      expect(newBoardList[0].pbEntries![0]?.columnId, controller.tabList[0].id);
      expect(newBoardList[0].pbEntries![1]?.columnId, controller.tabList[1].id);
      expect(newBoardList[0].pbEntries![2]?.columnId, controller.tabList[2].id);
      expect(newBoardList[0].pbEntries![3]?.columnId, controller.tabList[3].id);
    });

    test('ProgressBoardController@getBoardWidget should return Widget based on the type of data in pbEntries', () {

      controller.tabList = [];
      columnsJson["data"].forEach((dynamic board) => controller.tabList.add(ProductionBoardColumn.fromJson(board)));

      controller.boardList = [];
      jobJson["data"].forEach((dynamic board) => controller.boardList.add(JobModel.fromProgressBoardJson(board)));

      controller.boardList = controller.sortPBEntries(controller.boardList);

      expect(controller.getBoardWidget(controller.boardList[0].pbEntries, 0).runtimeType.toString(), "JPReadMoreText");
      expect(controller.getBoardWidget(controller.boardList[0].pbEntries, 1).runtimeType.toString(), "JPIconButton");
      expect(controller.getBoardWidget(controller.boardList[0].pbEntries, 2).runtimeType.toString(), "JPReadMoreText");
      expect(controller.getBoardWidget(controller.boardList[0].pbEntries, 3).runtimeType.toString(), "JPReadMoreText");
    });

    group('For change status of collapsible widget', () {
      controller.boardList = [];
      jobJson["data"].forEach((dynamic board) => controller.boardList.add(JobModel.fromProgressBoardJson(board)));
      test('ProgressBoardController@updateExpendableWidget should return null for initial state', () {
        expect(controller.boardList[0].isExpended, null);
      });

      test('ProgressBoardController@updateExpendableWidget should return true when collapsible widget is in expended form', () {
        controller.updateExpendableWidget(0);
        expect(controller.boardList[0].isExpended, true);
      });

      test('ProgressBoardController@updateExpendableWidget should return false when collapsible widget is in collapsible form', () {
        controller.updateExpendableWidget(0);
        expect(controller.boardList[0].isExpended, false);
      });
    });

    test("ProgressBoardController@isProgressBoardManageable should return true if 'manage_progress_board' permission matched in permission list", () {
      PermissionService.permissionList = permissionList;
      bool hasPermission = controller.isProgressBoardManageable();
      expect(hasPermission, true);
    });

  });

  group("For reorder able listing controller", () {
    ReorderAbleJobListingController reorderAbleJobListingController = ReorderAbleJobListingController();
    List<ProgressBoardModel> pbList = [];
    pbJson["data"].forEach((dynamic board) => pbList.add(ProgressBoardModel.fromJson(board)));
    reorderAbleJobListingController.filterKeys = controller.filterKeys;
    reorderAbleJobListingController.jobList = controller.boardList;
    reorderAbleJobListingController.tabList = controller.tabList;

    test('ProgressBoardController@loadMore should increase page count and load more data', () {
      int currentPage = reorderAbleJobListingController.filterKeys?.page ?? 0;

      reorderAbleJobListingController.onLoadMore();
      var params = reorderAbleJobListingController.filterKeys?.toJson();
      expect(reorderAbleJobListingController.isLoading, true);
      expect(params?["limit"], 20);
      expect(params?["page"], ++currentPage);
      expect(params?["sort_by"], "order");
      expect(params?["sort_order"], "asc");
      expect(params?["board_id"], 425);
      expect(params?["job_number"], null);
      expect(params?["job_alt_id"], null);
      expect(params?["job_address"], null);
      expect(params?["job_zip_code"], null);
      expect(params?["trade_id"], null);
    });

  });
}