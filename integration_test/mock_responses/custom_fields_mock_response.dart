// ignore_for_file: inference_failure_on_collection_literal

class CustomFieldsMockResponse {
  static const Map<String,dynamic> okResponse = {
    "data": [
      {
        "id": 218,
        "model_type": "job",
        "type": "dropdown",
        "required": true,
        "name": "Countries",
        "description": null,
        "default_value": null,
        "active": true,
        "order": 5,
        "value": null,
        "options": {
          "data": [
            {
              "id": 906,
              "name": "Country"
            },
            {
              "id": 909,
              "name": "State"
            },
            {
              "id": 915,
              "name": "City"
            }
          ]
        }
      },
      {
        "id": 219,
        "model_type": "job",
        "type": "text",
        "required": true,
        "name": "Required one",
        "description": null,
        "default_value": "TEST",
        "active": true,
        "order": 6,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 221,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "Age",
        "description": null,
        "default_value": "25",
        "active": true,
        "order": 8,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 222,
        "model_type": "job",
        "type": "text",
        "required": true,
        "name": "required field",
        "description": null,
        "default_value": "dummy1",
        "active": true,
        "order": 9,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 223,
        "model_type": "job",
        "type": "text",
        "required": true,
        "name": "Saloni Kochhar",
        "description": null,
        "default_value": null,
        "active": true,
        "order": 10,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 489,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "hi",
        "description": null,
        "default_value": "new",
        "active": true,
        "order": 11,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 490,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "Hello I am new",
        "description": null,
        "default_value": "i am default",
        "active": true,
        "order": 12,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 1324,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "Tanu Arora",
        "description": null,
        "default_value": null,
        "active": true,
        "order": 13,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 1325,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "Test field 1",
        "description": null,
        "default_value": null,
        "active": true,
        "order": 14,
        "value": null,
        "options": {
          "data": []
        }
      },
      {
        "id": 1326,
        "model_type": "job",
        "type": "text",
        "required": false,
        "name": "Test field 2",
        "description": null,
        "default_value": null,
        "active": true,
        "order": 15,
        "value": null,
        "options": {
          "data": []
        }
      }
    ],
    "meta": {
      "pagination": {
        "total": 10,
        "count": 10,
        "per_page": 150,
        "current_page": 1,
        "total_pages": 1,
        "links": []
      }
    },
    "status": 200
  };

  static const Map<String,dynamic> okDropDown1OptionsResponse = {
    "data": [
      {
        "id": 1162,
        "name": "option 1",
        "active": 1,
        "order": 1,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      },
      {
        "id": 1163,
        "name": "option 2",
        "active": 1,
        "order": 2,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      }
    ],
    "meta": {
      "pagination": {
        "total": 2,
        "count": 2,
        "per_page": 50,
        "current_page": 1,
        "total_pages": 1,
        "links": []
      }
    },
    "status": 200
  };

  static const Map<String,dynamic> okDropDown2OptionsResponse = {
    "data": [
      {
        "id": 1162,
        "name": "option 11",
        "active": 1,
        "order": 1,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      },
      {
        "id": 1163,
        "name": "option 12",
        "active": 1,
        "order": 2,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      }
    ],
    "meta": {
      "pagination": {
        "total": 2,
        "count": 2,
        "per_page": 50,
        "current_page": 1,
        "total_pages": 1,
        "links": []
      }
    },
    "status": 200
  };

  static const Map<String,dynamic> okDropDown3OptionsResponse = {
    "data": [
      {
        "id": 1162,
        "name": "option 21",
        "active": 1,
        "order": 1,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      },
      {
        "id": 1163,
        "name": "option 22",
        "active": 1,
        "order": 2,
        "total_linked_jobs": 0,
        "total_linked_customers": 0,
        "parent_id": 1161,
        "linked_parent_options": {
          "data": []
        }
      }
    ],
    "meta": {
      "pagination": {
        "total": 2,
        "count": 2,
        "per_page": 50,
        "current_page": 1,
        "total_pages": 1,
        "links": []
      }
    },
    "status": 200
  };
}

