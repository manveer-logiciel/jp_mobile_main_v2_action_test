
class TaskListingMockResponse {
  static const Map<String,dynamic> okResponse = {
    "data":[
      {
        "id":2695,
        "title":"Page1 : 1",
        "notes":"","due_date":"2023-05-01",
        "job_id":21665,
        "stage_code":"1816761216",
        "completed":null,
        "is_high_priority_task":0,
        "created_at":"2023-05-01 12:51:35",
        "updated_at":"2023-05-01 12:51:35",
        "notify_user_setting":<List<dynamic>>[],
        "assign_to_setting":<List<dynamic>>[],
        "locked":0,
        "reminder_type":null,
        "reminder_frequency":null,
        "is_due_date_reminder":0,
        "is_wf_task":0,
        "send_as_message":0,
        "created_by":{
          "id":1229,
          "first_name":"Moahammad",
          "last_name":"Zaid",
          "full_name":"Moahammad Zaid",
          "full_name_mobile":"Moahammad Zaid",
          "email":"zaid@logiciel.io",
          "group_id":5,
          "profile_pic":null,
          "color":"blue",
          "company_name":null,
          "total_commission":null,
          "paid_commission":null,
          "unpaid_commission":null,
          "all_divisions_access":true,
          "status":null
        },
        "participants":{
          "data":[
            {
              "id":1229,
              "first_name":"Moahammad",
              "last_name":"Zaid",
              "full_name":"Moahammad Zaid",
              "full_name_mobile":"Moahammad Zaid",
              "email":"zaid@logiciel.io",
              "group_id":5,
              "profile_pic":null,
              "color":"blue",
              "company_name":null,
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
              "id":1229,
              "first_name":"Moahammad",
              "last_name":"Zaid",
              "full_name":"Moahammad Zaid",
              "full_name_mobile":"Moahammad Zaid",
              "email":"zaid@logiciel.io",
              "group_id":5,
              "profile_pic":null,
              "color":"blue",
              "company_name":null,
              "total_commission":null,
              "paid_commission":null,
              "unpaid_commission":null,
              "all_divisions_access":true,
              "status":null
            }
          ]
        },
        "job":{
          "id":21665,
          "customer_id":19644,
          "number":"2212-19644-01",
          "name":"",
          "division_code":"",
          "alt_id":"",
          "spotio_lead_id":null,
          "source_type":null,
          "lead_number":"",
          "amount":"200",
          "taxable":0,
          "tax_rate":"",
          "invoice_id":null,
          "meta":{"resource_id":"149609","default_photo_dir":"149611"},
          "current_stage":{"name":"Work","color":"cl-purple","code":"1339296773","resource_id":149577,"last_stage_completed_date":null},
          "duration":"5:5:5",
          "completion_date":"2023-01-30",
          "contract_signed_date":null,
          "archived":null,
          "material_delivery_date":null,
          "post_office_number":null,
          "quickbook_id":0,
          "job_amount_approved_by":null,
          "created_at":"2022-12-08 04:27:00",
          "origin":"JobProgress",
          "ghost_job":null,
          "quickbook_sync_status":null,
          "qb_desktop_id":"",
          "updated_at":"2023-08-22 10:14:27",
          "bid_customer":0,
          "is_pmi":0,
          "pmi_id":"",
          "pmi_sync_status":0,
          "pmi_sync_type":null,
          "pmi_sync_message":null,
          "home_advisor_job_id":null,
          "multi_job":0,
          "customer":{
            "id":19644,
            "first_name":"Demo",
            "last_name":"User",
            "full_name":"Demo User",
            "full_name_mobile":"Demo User",
            "company_name":"",
            "email":"",
            "additional_emails":<List<dynamic>>[],
            "is_commercial":0,
            "referred_by_type":"",
            "source_type":"",
            "origin":"JobProgress",
            "bid_customer":0,
            "disable_qbo_sync":0,
            "disable_qbo_financial_syncing":0,
            "phones":{
              "data":[
                {
                  "label":"cell",
                  "number":"1111111111",
                  "ext":""
                }
              ]
            }
          },
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
              "phone_code":"+1"
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
        "stage":{
          "id":2829,
          "code":"1816761216",
          "workflow_id":387,
          "name":"Paid",
          "locked":1,
          "position":7,
          "color":"cl-skyblue"
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
          "additional_emails":<List<dynamic>>[],
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
          "unapplied_amount":55,
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
              "phone_code":"+1"
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
                "number":"1111111111",
                "ext":""
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
              "phone_code":"+1"
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
        "attachments":{
          "data":<List<dynamic>>[]
        }
      },
      {
        "id": 3142,
        "title": "Page1 : 2",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:44:05",
        "updated_at": "2023-07-18 09:44:05",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3141,
        "title": "Page1 : 3",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:43:23",
        "updated_at": "2023-07-18 09:43:23",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3140,
        "title": "Page1 : 4",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:42:22",
        "updated_at": "2023-07-18 09:42:22",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3139,
        "title": "Page1 : 5",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:41:47",
        "updated_at": "2023-07-18 09:41:47",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3138,
        "title": "Page1 : 6",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:41:03",
        "updated_at": "2023-07-18 09:41:03",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3137,
        "title": "Page1 : 7",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:40:18",
        "updated_at": "2023-07-18 09:40:18",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3136,
        "title": "Page1 : 8",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:43",
        "updated_at": "2023-07-18 09:36:43",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3135,
        "title": "Page1 : 9",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:01",
        "updated_at": "2023-07-18 09:36:01",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3134,
        "title": "Page1 : 10",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:35:07",
        "updated_at": "2023-07-18 09:35:07",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
    ],
    "meta": {
      "pagination":{
        "total":20,
        "count":10,
        "per_page":10,
        "current_page":1,
        "total_pages":2,
      }
    },
    "status":200
  };

  static const Map<String,dynamic> okResponse2 = {
    "data":[
      {
        "id": 3130,
        "title": "Page2 : 1",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3137,
        "title": "Page2 : 2",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:40:18",
        "updated_at": "2023-07-18 09:40:18",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3136,
        "title": "Page2 : 3",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:43",
        "updated_at": "2023-07-18 09:36:43",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3135,
        "title": "Page2 : 4",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:01",
        "updated_at": "2023-07-18 09:36:01",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3134,
        "title": "Page2 : 5",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:35:07",
        "updated_at": "2023-07-18 09:35:07",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page2 : 6",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page2 : 7",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page2 : 8",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page2 : 9",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page2 : 10",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
    ],
    "meta":{
      "pagination":{
        "total":20,
        "count":10,
        "per_page":10,
        "current_page":2,
        "total_pages":2,
      }
    },
    "status":200
  };

  static const Map<String,dynamic> noDataResponse = {
    "data":<List<dynamic>>[],
    "meta":{
      "pagination":{
        "total":0,
        "count":0,
        "per_page":10,
        "current_page":1,
        "total_pages":1,
      }
    },
    "status":200
  };

  static const Map<String,dynamic> okResponseDesc = {
    "data": [
      {
        "id": 3141,
        "title": "Page1 : 10",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:43:23",
        "updated_at": "2023-07-18 09:43:23",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3140,
        "title": "Page1 : 9",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:42:22",
        "updated_at": "2023-07-18 09:42:22",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3139,
        "title": "Page1 : 8",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:41:47",
        "updated_at": "2023-07-18 09:41:47",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3138,
        "title": "Page1 : 7",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:41:03",
        "updated_at": "2023-07-18 09:41:03",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3137,
        "title": "Page1 : 6",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:40:18",
        "updated_at": "2023-07-18 09:40:18",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3136,
        "title": "Page1 : 5",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:43",
        "updated_at": "2023-07-18 09:36:43",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3135,
        "title": "Page1 : 4",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:36:01",
        "updated_at": "2023-07-18 09:36:01",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3134,
        "title": "Page1 : 3",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 09:35:07",
        "updated_at": "2023-07-18 09:35:07",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 3130,
        "title": "Page1 : 2",
        "notes": "",
        "due_date": null,
        "job_id": null,
        "stage_code": null,
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-07-18 08:52:34",
        "updated_at": "2023-07-18 08:52:34",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "attachments": {
          "data": <List<dynamic>>[]
        }
      },
      {
        "id": 2695,
        "title": "Page1 : 1",
        "notes": "",
        "due_date": "2023-05-01",
        "job_id": 21665,
        "stage_code": "1816761216",
        "completed": null,
        "is_high_priority_task": 0,
        "created_at": "2023-05-01 12:51:35",
        "updated_at": "2023-05-01 12:51:35",
        "notify_user_setting": <List<dynamic>>[],
        "assign_to_setting": <List<dynamic>>[],
        "locked": 0,
        "reminder_type": null,
        "reminder_frequency": null,
        "is_due_date_reminder": 0,
        "is_wf_task": 0,
        "send_as_message": 0,
        "created_by": {
          "id": 1229,
          "first_name": "Moahammad",
          "last_name": "Zaid",
          "full_name": "Moahammad Zaid",
          "full_name_mobile": "Moahammad Zaid",
          "email": "zaid@logiciel.io",
          "group_id": 5,
          "profile_pic": null,
          "color": "blue",
          "company_name": null,
          "total_commission": null,
          "paid_commission": null,
          "unpaid_commission": null,
          "all_divisions_access": true,
          "status": null
        },
        "participants": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "notify_users": {
          "data": [
            {
              "id": 1229,
              "first_name": "Moahammad",
              "last_name": "Zaid",
              "full_name": "Moahammad Zaid",
              "full_name_mobile": "Moahammad Zaid",
              "email": "zaid@logiciel.io",
              "group_id": 5,
              "profile_pic": null,
              "color": "blue",
              "company_name": null,
              "total_commission": null,
              "paid_commission": null,
              "unpaid_commission": null,
              "all_divisions_access": true,
              "status": null
            }
          ]
        },
        "job": {
          "id": 21665,
          "customer_id": 19644,
          "number": "2212-19644-01",
          "name": "",
          "division_code": "",
          "alt_id": "",
          "spotio_lead_id": null,
          "source_type": null,
          "lead_number": "",
          "amount": null,
          "taxable": 0,
          "tax_rate": "",
          "invoice_id": null,
          "meta": {
            "resource_id": "149609",
            "default_photo_dir": "149611"
          },
          "current_stage": {
            "name": "Work",
            "color": "cl-purple",
            "code": "1339296773",
            "resource_id": 149577,
            "last_stage_completed_date": null
          },
          "duration": "5:5:5",
          "completion_date": "2023-01-30",
          "contract_signed_date": null,
          "archived": null,
          "material_delivery_date": null,
          "post_office_number": null,
          "quickbook_id": 0,
          "job_amount_approved_by": null,
          "created_at": "2022-12-08 04:27:00",
          "origin": "JobProgress",
          "ghost_job": null,
          "quickbook_sync_status": null,
          "qb_desktop_id": "",
          "updated_at": "2023-08-22 11:57:16",
          "bid_customer": 0,
          "is_pmi": 0,
          "pmi_id": "",
          "pmi_sync_status": 0,
          "pmi_sync_type": null,
          "pmi_sync_message": null,
          "home_advisor_job_id": null,
          "multi_job": 0,
          "customer": {
            "id": 19644,
            "first_name": "Demo",
            "last_name": "User",
            "full_name": "Demo User",
            "full_name_mobile": "Demo User",
            "company_name": "",
            "email": "",
            "additional_emails": <List<dynamic>>[],
            "is_commercial": 0,
            "referred_by_type": "",
            "source_type": "",
            "origin": "JobProgress",
            "bid_customer": 0,
            "disable_qbo_sync": 0,
            "disable_qbo_financial_syncing": 0,
            "phones": {
              "data": [
                {
                  "label": "cell",
                  "number": "1111111111",
                  "ext": ""
                }
              ]
            }
          },
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
              "phone_code": "+1"
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
        "stage": {
          "id": 2829,
          "code": "1816761216",
          "workflow_id": 387,
          "name": "Paid",
          "locked": 1,
          "position": 7,
          "color": "cl-skyblue"
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
          "additional_emails": <List<dynamic>>[],
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
          "unapplied_amount": 55,
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
              "phone_code": "+1"
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
                "number": "1111111111",
                "ext": ""
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
              "phone_code": "+1"
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
        "attachments": {
          "data": <List<dynamic>>[]
        }
      }
    ],
    "meta": {
      "pagination": {
        "total": 10,
        "count": 10,
        "per_page": 10,
        "current_page": 1,
        "total_pages": 1,
        "links": <List<dynamic>>[]
      }
    },
    "status": 200
  };
}