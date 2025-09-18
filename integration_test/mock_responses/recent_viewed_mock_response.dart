import 'package:jobprogress/common/models/schedules/job_type.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'common/meta_mock_response.dart';

class RecentViewedMockResponse {

  static  Map<String,dynamic> okResponse = {
    "data":[
      {
        "id":21665,
        "name":"",
        "number":"2212-19644-01",
        "trades":[
          {
            "id":24,
            "name":"OTHER",
            "pivot":{
              "job_id":21665,
              "trade_id":24
            }
          }
        ],
        "work_types":<WorkTypeModel>[],
        "customer_id":19644,
        "description":"Marketing",
        "same_as_customer_address":1,
        "amount":null,
        "other_trade_type_description":"Marketing",
        "spotio_lead_id":null,
        "source_type":null,
        "created_by":1229,
        "created_at":"2022-12-08 04:27:00",
        "created_date":"2022-12-08 04:27:00",
        "updated_at":"2023-01-16 05:16:07",
        "stage_changed_date":null,
        "distance":null,
        "deleted_at":null,
        "call_required":false,
        "appointment_required":false,
        "taxable":0,
        "job_types":<JobType>[],
        "tax_rate":null,
        "division_code":"",
        "alt_id":"",
        "lead_number":"",
        "duration":"0:0:0",
        "completion_date":null,
        "contract_signed_date":null,
        "to_be_scheduled":null,
        "current_stage":{
          "name": "Paid",
          "color": "cl-skyblue",
          "code":'1854880704',
          "resource_id":149572
        },
        "meta":{
          "resource_id":'149609',
          "default_photo_dir":'149611'
        },
        "has_profit_loss_worksheet":false,
        "has_selling_price_worksheet":false,
        "stage_last_modified":"2022-12-08 04:27:01",
        "share_token":"167047362063916794b73bb",
        "contact_same_as_customer":1,
        "is_old_trade":false,
        "sold_out_date":null,
        "insurance":0,
        "archived":null,
        "archived_cwp":null,
        "scheduled":null,
        "schedule_count":null,
        "wp_job":0,
        "sync_on_hover":0,
        "hover_user_email":null,
        "material_delivery_date":null,
        "purchase_order_number":"New",
        "quickbook_id":0,
        "job_amount_approved_by":null,
        "display_order":0,
        "origin":"JobProgress",
        "ghost_job":null,
        "quickbook_sync_status":null,
        "qb_desktop_id":"",
        "new_folder_structure":true,
        "bid_customer":0,
        "is_pmi":0,
        "pmi_id":"",
        "pmi_sync_status":0,
        "pmi_sync_type":null,
        "pmi_sync_message":null,
        "home_advisor_job_id":null,
        "multi_job":0,
        "address":{
          "id":76282,
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
          "created_by":1229,
          "updated_by":1229,
          "update_origin":null,
          "updated_from":null,
          "device_uuid":null,
          "created_at":"2022-12-08 04:25:40",
          "updated_at":"2022-12-08 04:27:01"
        },
        "reps":{
        "data":<UserLimitedModel>[]
      },
        "estimators":{
        "data":<UserLimitedModel>[]
      },
        "customer":{
        "id":19644,
        "company_name":"",
        "address_id":76282,
        "billing_address_id":76282,
        "first_name":"Demo",
        "last_name":"User",
        "full_name":"Demo User",
        "full_name_mobile":"Demo User",
        "email":"",
        "source_type":"",
        "additional_emails":<String>[],
        "rep_id":null,
        "distance":null,
        "referred_by_type":"",
        "referred_by_note":"",
        "jobs_count":null,
        "total_jobs_count":1,
        "call_required":false,
        "appointment_required":false,
        "note":"",
        "is_commercial":0,
        "created_at":"2022-12-08 04:25:40",
        "deleted_at":null,
        "unapplied_amount":0,
        "management_company":"",
        "property_name":"",
        "quickbook_id":null,
        "canvasser_type":null,
        "canvasser":null,
        "call_center_rep_type":null,
        "call_center_rep":null,
        "quickbook_sync_status":null,
        "disable_qbo_sync":0,
        "origin":"JobProgress",
        "qb_desktop_id":null,
        "new_folder_structure":false,
        "bid_customer":0,
        "is_prime_contractor_customer":0,
        "disable_qbo_financial_syncing":false,
        "address":{
          "id":76282,
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
          "created_by":1229,
          "updated_by":1229,
          "update_origin":null,
          "updated_from":null,
          "device_uuid":null,
          "created_at":"2022-12-08 04:25:40",
          "updated_at":"2022-12-08 04:27:01"
        },
        "phones":{
          "data":[
            {
              "label":"cell",
              "number":1111111111,
              "ext": ''
            }
          ]
        },
        "billing":{
          "id":76282,
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
          "created_by":1229,
          "updated_by":1229,
          "update_origin":null,
          "updated_from":null,
          "device_uuid":null,
          "created_at":"2022-12-08 04:25:40",
          "updated_at":"2022-12-08 04:27:01"
        }
      },
        "job_workflow":{
        "id":21632,
        "current_stage_code":"1854880704",
        "modified_by":1229,
        "stage_last_modified":"2022-12-08 04:27:01",
        "created_at":"2022-12-08 04:27:01",
        "updated_at":"2022-12-08 04:27:01",
        "current_stage":{
          "id":2823,
          "code":"1854880704",
          "workflow_id":387,
          "name":"Lead",
          "locked":1,
          "position":1,
          "color":"cl-red",
          "options":null,
          "resource_id":149572,
          "send_customer_email":0,
          "send_push_notification":0,
          "send_web_notification":0,
          "create_tasks":0
        },
          "last_stage_completed_date":null
      },
        "resource_ids":{
        "workflow_resource_id":149571,
        "company_resource_id":149569
      },
        "labours":{
          "data":<UserLimitedModel>[]
        },
        "sub_contractors":{
        "data":<UserLimitedModel>[]
      }
      }
    ],
    "meta":MetaMockResponse.value,
    "status":200
  };
}