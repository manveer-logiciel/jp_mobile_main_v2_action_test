import 'common/meta_mock_response.dart';

class JobListingMockResponse {
  static const Map<String, dynamic> okResponse = {
    "data":[
      {
        "id":21665,
        "name":"",
        "number":"2308-4249-09",
        "trades":[
          {
            "id":57,
            "name":"AIR QUALITY SERVICES",
            "pivot":{
              "job_id":21665,
              "trade_id":57
            }
          }
        ],
        "work_types":[
          {
            "id":227,
            "trade_id":57,
            "name":"888",
            "type":2,
            "order":0,
            "color":"#9C2542",
            "insurance_claim":false,
            "pivot":{
              "job_id":21665,
              "job_type_id":227
            }
          }
        ],
        "customer_id":4249,
        "description":"Sample",
        "same_as_customer_address":1,
        "created_by":4896,
        "created_at":"2023-08-23 10:12:33",
        "created_date":"2023-08-23 10:12:33",
        "updated_at":"2023-08-23 10:15:06",
        "stage_changed_date":"2023-08-23 10:12:33",
        "call_required":false,
        "appointment_required":false,
        "taxable":0,
        "alt_id":"test-35",
        "lead_number":"",
        "duration":"0:0:0",
        "current_stage":{
          "name":"Lead",
          "color":"cl-skyblue",
          "code":"213719552",
          "resource_id":218
        },
        "meta":{
          "resource_id":"212195",
          "default_photo_dir":"212196",
          "company_cam_id":"54122157"
        },
        "share_url":"https://dev.jobprog.net/marketing/#/customer/169278555364e5db915dada/public-page",
        "insurance":0,
        "quickbook_id":0,
        "wp_job":0,
        "division_code":"",
        "origin":"JobProgress",
        "qb_desktop_id":"",
        "bid_customer":1,
        "is_pmi":0,
        "pmi_id":"",
        "pmi_sync_status":0,
        "multi_job":0,
        "address":{
          "id":180523,
          "address":"",
          "address_line_1":"",
          "city":"",
          "state_id":0,
          "country_id":0,
          "geocoding_error":1,
          "created_by":33,
          "updated_by":33,
          "created_at":"2023-05-05 06:04:51",
          "updated_at":"2023-05-06 00:00:08"
        },
        "customer":{
          "id":4249,
          "first_name":"Dfsdf",
          "last_name":"Df",
          "full_name":"Dfsdf Df",
          "full_name_mobile":"Dfsdf Df",
          "company_name":"",
          "email":"",
          "is_commercial":0,
          "referred_by_type":"",
          "source_type":"",
          "origin":"JobProgress",
          "bid_customer":1,
          "disable_qbo_sync":0,
          "disable_qbo_financial_syncing":0,
          "phones":{
            "data":[
              {
                "label":"home",
                "number":"0000000000",
              }
            ]
          }
        },
        "job_workflow":{
          "id":26230,
          "current_stage_code":"213719552",
          "modified_by":4896,
          "stage_last_modified":"2023-08-23 10:12:33",
          "created_at":"2023-08-23 10:12:34",
          "updated_at":"2023-08-23 10:12:34",
          "current_stage":{
            "id":9086,
            "code":"213719552",
            "workflow_id":1192,
            "name":"Lead",
            "locked":1,
            "position":1,
            "color":"cl-skyblue",
            "options":{
              "description":"<h1>it is <span style=\"font-size:11px;\">LeadStage</span></h1>\n"
            },
            "resource_id":218,
            "send_customer_email":1,
            "send_push_notification":0,
            "send_web_notification":0,
            "create_tasks":0
          },
        },
      },
    ],
    "meta":MetaMockResponse.value,
    "status":200
  };
}