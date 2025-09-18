class JobNotesMockResponse {
  static const Map<String, dynamic> okResponse = {
    "data": [
      {
        "id": 864,
        "stage_code": "213719552",
        "note": "An appointment has been created with Gurpreet Singh / 2006-2745-05 for Pawan Arora on 24th Jun, 2020 at 10:00 pm(America/New_York).",
        "object_id": 175,
        "created_at": "2020-06-24 15:35:02",
        "updated_at": "2020-06-24 15:35:02",
        "created_by": {
          "id": 33,
          "first_name": "Rahul",
          "last_name": "Anand",
          "full_name": "Rahul Anand",
          "full_name_mobile": "Rahul Anand",
          "email": "pawan.arora@logicielsolutions.co.in",
          "group_id": 5,
          "profile_pic": "https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F33_1689057623.jpg",
          "color": "blue",
          "all_divisions_access": true,
          "status": null
        },
        "stage": {
          "id": 9086,
          "code": "213719552",
          "workflow_id": 1192,
          "name": "Lead",
          "locked": 1,
          "position": 1,
          "color": "cl-skyblue"
        },
        "appointment": {
          "id": 6496,
          "title": "Singh / AWNINGS & CANOPIES",
          "description": "",
          "start_date_time": "2020-06-25 02:00:00",
          "end_date_time": "2020-06-25 03:00:00",
          "location": "",
          "customer_id": 2745,
          "job_id": 0,
          "user_id": 33,
          "full_day": 0,
          "location_type": "job",
          "is_recurring": false,
          "interval": 1,
          "is_completed": false,
          "updated_at": "2020-06-24 15:34:59",
          "created_at": "2020-06-24 15:34:59",
          "user": {
            "id": 33,
            "first_name": "Rahul",
            "last_name": "Anand",
            "full_name": "Rahul Anand",
            "full_name_mobile": "Rahul Anand",
            "email": "pawan.arora@logicielsolutions.co.in",
            "group_id": 5,
            "profile_pic": "https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F33_1689057623.jpg",
            "color": "blue",
            "all_divisions_access": true,
          }
        },
      }
    ],
    "meta": {
      "pagination": {
        "total": 1,
        "count": 1,
        "per_page": 20,
        "current_page": 1,
        "total_pages": 1,
      }
    },
    "status": 200
  };
}