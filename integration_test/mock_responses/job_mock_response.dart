import 'package:jobprogress/common/models/job/job_production_board.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';

class JobMockResponse {

  static Map<String, dynamic> okResponse = {
        "data": {
          "id": 21665,
          "name": "",
          "number": "2212-19644-01",
          "trades": [
            {
              "id": 24,
              "name": "OTHER",
              "pivot": {
                "job_id": 21665,
                "trade_id": 24
              }
            }
          ],
          "work_types": <WorkTypeModel>[],
          "customer_id": 19644,
          "description": "Marketing",
          "same_as_customer_address": 1,
          "amount": null,
          "other_trade_type_description": "Marketing",
          "spotio_lead_id": null,
          "source_type": null,
          "created_by": 1229,
          "created_at": "2022-12-08 04:27:00",
          "created_date": "2022-12-08 04:27:00",
          "updated_at": "2023-01-16 05:16:07",
          "stage_changed_date": null,
          "distance": null,
          "deleted_at": null,
          "call_required": false,
          "appointment_required": false,
          "taxable": 0,
          "job_types": <JobTypeModel>[],
          "tax_rate": null,
          "division_code": "",
          "alt_id": "",
          "lead_number": "",
          "duration": "0:0:0",
          "completion_date": null,
          "contract_signed_date": null,
          "to_be_scheduled": null,
          "current_stage": {
            "name":  "Lead",
            "color": "cl-red",
            "code": "1854880704",
            "resource_id": 149572,
            "incomplete_task_lock_count": 0
          },
          "meta": {
            "resource_id": '149609',
            "default_photo_dir": '149611'
          },
          "has_profit_loss_worksheet": false,
          "has_selling_price_worksheet": false,
          "stage_last_modified": "2022-12-08 04:27:01",
          "share_token": "167047362063916794b73bb",
          "contact_same_as_customer": 1,
          "is_old_trade": false,
          "sold_out_date": null,
          "moved_to_pb": null,
          "insurance": 0,
          "archived": null,
          "archived_cwp": null,
          "scheduled": null,
          "schedule_count": null,
          "wp_job": 0,
          "sync_on_hover": 0,
          "hover_user_email": null,
          "material_delivery_date": null,
          "purchase_order_number": "New",
          "quickbook_id": 0,
          "job_amount_approved_by": null,
          "display_order": 0,
          "origin": "JobProgress",
          "ghost_job": null,
          "quickbook_sync_status": null,
          "qb_desktop_id": "",
          "new_folder_structure": true,
          "bid_customer": 0,
          "is_pmi": 0,
          "pmi_id": "",
          "pmi_sync_status": 0,
          "pmi_sync_type": null,
          "pmi_sync_message": null,
          "home_advisor_job_id": null,
          "multi_job": 0,
          "address": {
            "id": 76282,
            "address": "",
            "address_line_1": "",
            "city": "",
            "state_id": 0,
            "state": null,
            "country_id": 1,
            "country": {
              "id": 1,
              "name": "United States",
              "code": "US",
              "currency_name": "Doller",
              "currency_symbol": "\$",
              "phone_code": "+91"
            },
            "zip": null,
            "lat": null,
            "long": null,
            "geocoding_error": 1,
            "created_by": 1229,
            "updated_by": 1229,
            "update_origin": null,
            "updated_from": null,
            "device_uuid": null,
            "created_at": "2022-12-08 04:25:40",
            "updated_at": "2022-12-08 04:27:01"
          },
           "reps": {
            "data": 
            [
                {
                    "id": 1229,
                    "first_name": "Moahammad",
                    "last_name": "Zaid",
                    "full_name": "Moahammad Zaid",
                    "full_name_mobile": "Moahammad Zaid",
                    "email": "zaid@logiciel.io",
                    "company_id": 15395,
                    "company": "Goody",
                    "admin_privilege": false,
                    "group": {
                        "id": 5,
                        "name": "owner"
                    },
                    "role": [
                        {
                            "name": "plus-admin",
                            "pivot": {
                                "user_id": 1229,
                                "role_id": 4
                            }
                        }
                    ],
                    "departments": <void>[],
                    "added_date": "2022-12-07 12:48:41",
                    "profile_pic": null,
                    "active": true,
                    "company_name": null,
                    "color": "blue",
                    "commission_percentage": null,
                    "resource_id": null,
                    "data_masking": 0,
                    "multiple_account": 0,
                    "all_divisions_access": true,
                    "profile": {
                        "id": 1213,
                        "user_id": 1229,
                        "phone": null,
                        "additional_phone": null,
                        "address": "1342 Moneda",
                        "address_line_1": "",
                        "city": "Santiago",
                        "state_id": 1,
                        "state": "Alabama",
                        "state_code": "AL",
                        "country_id": 1,
                        "country": "United States",
                        "zip": "51000",
                        "position": "",
                        "profile_pic": null
                    }
                },
                {
                    "id": 1220,
                    "first_name": "Mohammad",
                    "last_name": "Zaid",
                    "full_name": "Mohammad Zaid",
                    "full_name_mobile": "Mohammad Zaid Mansuri",
                    "email": "zaid@logiciel.io",
                    "company_id": 15395,
                    "company": "Goody",
                    "admin_privilege": false,
                    "group": {
                        "id": 5,
                        "name": "owner"
                    },
                    "role": [
                        {
                            "name": "plus-admin",
                            "pivot": {
                                "user_id": 1229,
                                "role_id": 4
                            }
                        }
                    ],
                    "departments": <void>[],
                    "added_date": "2022-12-07 12:48:41",
                    "profile_pic": null,
                    "active": true,
                    "company_name": null,
                    "color": "blue",
                    "commission_percentage": null,
                    "resource_id": null,
                    "data_masking": 0,
                    "multiple_account": 0,
                    "all_divisions_access": true,
                    "profile": {
                        "id": 1213,
                        "user_id": 1229,
                        "phone": null,
                        "additional_phone": null,
                        "address": "1342 Moneda",
                        "address_line_1": "",
                        "city": "Santiago",
                        "state_id": 1,
                        "state": "Alabama",
                        "state_code": "AL",
                        "country_id": 1,
                        "country": "United States",
                        "zip": "51000",
                        "position": "",
                        "profile_pic": null
                    }
                }
            ]
        },
          "estimators": {
            "data": <UserLimitedModel>[]
          },
          "customer": {
            "id": 19644,
            "company_name": "",
            "address_id": 76282,
            "billing_address_id": 76282,
            "first_name": "Demo",
            "last_name": "User",
            "full_name": "Demo User",
            "full_name_mobile": "Demo User",
            "email": "",
            "source_type": "",
            "additional_emails": <String>[],
            "rep_id": null,
            "distance": null,
            "referred_by_type": "",
            "referred_by_note": "",
            "jobs_count": null,
            "total_jobs_count": 1,
            "call_required": false,
            "appointment_required": false,
            "note": "",
            "is_commercial": 0,
            "created_at": "2022-12-08 04:25:40",
            "deleted_at": null,
            "unapplied_amount": 0,
            "management_company": "",
            "property_name": "",
            "quickbook_id": null,
            "canvasser_type": null,
            "canvasser": null,
            "call_center_rep_type": null,
            "call_center_rep": null,
            "quickbook_sync_status": null,
            "disable_qbo_sync": 0,
            "origin": "JobProgress",
            "qb_desktop_id": null,
            "new_folder_structure": false,
            "bid_customer": 0,
            "is_prime_contractor_customer": 0,
            "disable_qbo_financial_syncing": false,
            "address": {
              "id": 76282,
              "address": "",
              "address_line_1": "",
              "city": "",
              "state_id": 0,
              "state": null,
              "country_id": 1,
              "country": {
                "id": 1,
                "name": "United States",
                "code": "US",
                "currency_name": "Doller",
                "currency_symbol": "\$",
                "phone_code": "+91"
              },
              "zip": null,
              "lat": null,
              "long": null,
              "geocoding_error": 1,
              "created_by": 1229,
              "updated_by": 1229,
              "update_origin": null,
              "updated_from": null,
              "device_uuid": null,
              "created_at": "2022-12-08 04:25:40",
              "updated_at": "2022-12-08 04:27:01"
            },
            "phones": {
              "data": [
                {
                  "label": "cell",
                  "number": 1111111111,
                  "ext": ''
                }
              ]
            },
            "billing": {
              "id": 76282,
              "address": "",
              "address_line_1": "",
              "city": "",
              "state_id": 0,
              "state": null,
              "country_id": 1,
              "country": {
                "id": 1,
                "name": "United States",
                "code": "US",
                "currency_name": "Doller",
                "currency_symbol": "\$",
                "phone_code": "+91"
              },
              "zip": null,
              "lat": null,
              "long": null,
              "geocoding_error": 1,
              "created_by": 1229,
              "updated_by": 1229,
              "update_origin": null,
              "updated_from": null,
              "device_uuid": null,
              "created_at": "2022-12-08 04:25:40",
              "updated_at": "2022-12-08 04:27:01"
            }
          },
          "job_workflow": {
            "id": 21632,
            "current_stage_code": "1854880704",
            "modified_by": 1229,
            "stage_last_modified": "2022-12-08 04:27:01",
            "created_at": "2022-12-08 04:27:01",
            "updated_at": "2022-12-08 04:27:01",
            "current_stage": {
              "id": 2823,
              "code": "1854880704",
              "workflow_id": 387,
              "name": "Lead",
              "locked": 1,
              "position": 1,
              "color": "cl-red",
              "options": null,
              "resource_id": 149572,
              "send_customer_email": 0,
              "send_push_notification": 0,
              "send_web_notification": 0,
              "create_tasks": 0
            },
            "last_stage_completed_date": null
          },
          "resource_ids": {
            "workflow_resource_id": 149571,
            "company_resource_id": 149569
          },
          "labours": {
            "data": <UserLimitedModel>[]
          },
          "sub_contractors": {
            "data": <UserLimitedModel>[]
          },
          "job_workflow_history": {
            "data": [
              {
                "id": 79644,
                "stage": "1854880704",
                "start_date": '"2022-12-08 04":"27":01',
                "completed_date": '"2023-01-30 09":"54":36',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":36',
                "updated_at": '"2023-01-30 09":"54":36'
              },
              {
                "id": 79645,
                "stage": "686715212",
                "start_date": '"2023-01-30 09":"54":36',
                "completed_date": '"2023-01-30 09":"54":40',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":40',
                "updated_at": '"2023-01-30 09":"54":40'
              },
              {
                "id": 79646,
                "stage": "714966363",
                "start_date": '"2023-01-30 09":"54":40',
                "completed_date": '"2023-01-30 09":"54":46',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":46',
                "updated_at": '"2023-01-30 09":"54":46'
              },
              {
                "id": 79647,
                "stage": "1135201399",
                "start_date": '"2023-01-30 09":"54":46',
                "completed_date": '"2023-01-30 09":"54":46',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":46',
                "updated_at": '"2023-01-30 09":"54":46'
              },
              {
                "id": 79648,
                "stage": "345657766",
                "start_date": '"2023-01-30 09":"54":46',
                "completed_date": '"2023-01-30 09":"54":46',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":46',
                "updated_at": '"2023-01-30 09":"54":46'
              },
              {
                "id": 79649,
                "stage": "1339296773",
                "start_date": '"2023-01-30 09":"54":46',
                "completed_date": '"2023-01-30 09":"54":46',
                "modified_by": 1229,
                "approved_by": null,
                "created_at": '"2023-01-30 09":"54":46',
                "updated_at": '"2023-01-30 09":"54":46'
              }
            ]
          },
          "count": {
            "estimates": 0,
            "measurements": 0,
            "proposals": 0,
            "work_orders": 0,
            "material_lists": 0,
            "work_crew_notes": 0,
            "job_resources": 1,
            "stage_resources": 0,
            "tasks": 0
          },
          "flags": {
            "data": <FlagModel>[]
          },
          "workflow": {
            "stages": [
              {
                "id": 2823,
                "code": "1854880704",
                "workflow_id": 387,
                "name": "Lead",
                "locked": 1,
                "position": 1,
                "color": "cl-red",
                "options": null,
                "resource_id": 149572,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2824,
                "code": "686715212",
                "workflow_id": 387,
                "name": "Estimate",
                "locked": 0,
                "position": 2,
                "color": "cl-orange",
                "options": null,
                "resource_id": 149573,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2825,
                "code": "714966363",
                "workflow_id": 387,
                "name": "Proposal",
                "locked": 0,
                "position": 3,
                "color": "cl-yellow",
                "options": null,
                "resource_id": 149574,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2826,
                "code": "1135201399",
                "workflow_id": 387,
                "name": "Follow Up",
                "locked": 0,
                "position": 4,
                "color": "cl-lime",
                "options": null,
                "resource_id": 149575,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2827,
                "code": "345657766",
                "workflow_id": 387,
                "name": "Contract",
                "locked": 0,
                "position": 5,
                "color": "cl-blue",
                "options": null,
                "resource_id": 149576,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2828,
                "code": "1339296773",
                "workflow_id": 387,
                "name": "Work",
                "locked": 0,
                "position": 6,
                "color": "cl-purple",
                "options": null,
                "resource_id": 149577,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              },
              {
                "id": 2829,
                "code": "1816761216",
                "workflow_id": 387,
                "name": "Paid",
                "locked": 1,
                "position": 7,
                "color": "cl-skyblue",
                "options": null,
                "resource_id": 149578,
                "send_customer_email": 0,
                "send_push_notification": 0,
                "send_web_notification": 0,
                "create_tasks": 0
              }
            ]
          },
          "production_boards": {
            "data": <JobProductionBoardModel>[]
          },
          "job_message_count": {
            "count": 0
          },
          "job_task_count": {
            "count": 0
          },
          "upcoming_appointment_count": {
            "count": 0
          },
          "Job_note_count": {
            "count": 0
          },
          "contacts": {
            "data": <Null>[]
          }
        },
        "status": 200
      };
}