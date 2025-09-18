class UserCompanyMockResponse {

  static const Map<String,dynamic> okResponse = {
    "data":{
      "id":1229,
      "first_name":"Mohammad",
      "last_name":"Zaid",
      "full_name":"Mohammad Zaid",
      "full_name_mobile":"Mohammad Zaid",
      "email":"zaid@logiciel.io",
      "company_id":15012,
      "company":"Goody",
      "admin_privilege":false,
      "group":{
        "id":1,
        "name":"owner"
      },
      "role":[
        {
          "name":"plus-admin",
          "pivot":{
            "user_id":1229,
            "role_id":4
          }
        }
      ],
      "departments":<Null>[

      ],
      "added_date":"2022-12-07 12:48:41",
      "profile_pic":null,
      "active":true,
      "company_name":null,
      "color":"blue",
      "commission_percentage":null,
      "resource_id":null,
      "data_masking":0,
      "multiple_account":0,
      "all_divisions_access":true,
      "profile":{
        "id":1213,
        "user_id":1229,
        "phone":null,
        "additional_phone":null,
        "address":"1342 Moneda",
        "address_line_1":"",
        "city":"Santiago",
        "state_id":1,
        "state":"Alabama",
        "state_code":"AL",
        "country_id":1,
        "country":"United States",
        "zip":"51000",
        "position":"",
        "profile_pic":null
      },
      "company_details":{
        "id":15012,
        "company_name":"Goody",
        "office_email":"zaid@logicielsolutions.co.in",
        "office_additional_email":['2'],
        "office_phone":"1234567900",
        "office_additional_phone":['2'],
        "office_address":"1342 Moneda",
        "office_address_line_1":"",
        "office_fax":"",
        "office_street":null,
        "office_city":"Santiago",
        "office_zip":"51000",
        "office_state_id":1,
        "office_state":{
          "id":1,
          "name":"Alabama",
          "code":"AL",
          "country_id":1
        },
        "office_country_id":1,
        "office_country":{
          "id":1,
          "name":"United States",
          "code":"US",
          "currency_name":"Doller",
          "currency_symbol":"\$",
          "phone_code":"+91"
        },
        "logo":null,
        "created_at":"2022-12-07 12:48:41",
        "account_manager_id":0,
        "subscriber_resource_id":149569,
        "deleted_at":null,
        "phone_format":"(999) 999-9999",
        "license_number":null,
        "signup_origin":"manually"
      },
      "divisions":{
        "data":[
          {
            "id":1,
            "name":"Demo Division",
            "code":"1"
          }
        ]
      },
      "all_companies":{
        "data":[
          {
            "id":15012,
            "company_name":"Goody",
            "office_email":"zaid@logicielsolutions.co.in",
            "office_additional_email":['2'],
            "office_phone":"1234567900",
            "office_additional_phone":['2'],
            "office_address":"1342 Moneda",
            "office_address_line_1":"",
            "office_fax":"",
            "office_street":null,
            "office_city":"Santiago",
            "office_zip":"51000",
            "office_state_id":1,
            "office_state":{
              "id":1,
              "name":"Alabama",
              "code":"AL",
              "country_id":1
            },
            "office_country_id":1,
            "office_country":{
              "id":1,
              "name":"United States",
              "code":"US",
              "currency_name":"Doller",
              "currency_symbol":"\$",
              "phone_code":"+91"
            },
            "logo":null,
            "created_at":"2022-12-07 12:48:41",
            "account_manager_id":0,
            "subscriber_resource_id":149569,
            "deleted_at":null,
            "phone_format":"(999) 999-9999",
            "license_number":null,
            "signup_origin":"manually"
          }
        ]
      }
    },
    "status":200
  };

  static const Map<String,dynamic> okResponseList = {
    "data":[
      {
        "id":1229,
        "first_name":"Mohammad",
        "last_name":"Zaid",
        "full_name":"Mohammad Zaid",
        "full_name_mobile":"Mohammad Zaid",
        "email":"zaid@logiciel.io",
        "company_id":15012,
        "company":"Goody",
        "admin_privilege":false,
        "group":{
          "id":1,
          "name":"owner"
        },
        "role":[
          {
            "name":"plus-admin",
            "pivot":{
              "user_id":1229,
              "role_id":4
            }
          }
        ],
        "departments":<Null>[

        ],
        "added_date":"2022-12-07 12:48:41",
        "profile_pic":null,
        "active":true,
        "company_name":null,
        "color":"blue",
        "commission_percentage":null,
        "resource_id":null,
        "data_masking":0,
        "multiple_account":0,
        "all_divisions_access":true,
        "profile":{
          "id":1213,
          "user_id":1229,
          "phone":null,
          "additional_phone":null,
          "address":"1342 Moneda",
          "address_line_1":"",
          "city":"Santiago",
          "state_id":1,
          "state":"Alabama",
          "state_code":"AL",
          "country_id":1,
          "country":"United States",
          "zip":"51000",
          "position":"",
          "profile_pic":null
        },
        "company_details":{
          "id":15012,
          "company_name":"Goody",
          "office_email":"zaid@logicielsolutions.co.in",
          "office_additional_email":['2'],
          "office_phone":"1234567900",
          "office_additional_phone":['2'],
          "office_address":"1342 Moneda",
          "office_address_line_1":"",
          "office_fax":"",
          "office_street":null,
          "office_city":"Santiago",
          "office_zip":"51000",
          "office_state_id":1,
          "office_state":{
            "id":1,
            "name":"Alabama",
            "code":"AL",
            "country_id":1
          },
          "office_country_id":1,
          "office_country":{
            "id":1,
            "name":"United States",
            "code":"US",
            "currency_name":"Doller",
            "currency_symbol":"\$",
            "phone_code":"+91"
          },
          "logo":null,
          "created_at":"2022-12-07 12:48:41",
          "account_manager_id":0,
          "subscriber_resource_id":149569,
          "deleted_at":null,
          "phone_format":"(999) 999-9999",
          "license_number":null,
          "signup_origin":"manually"
        },
        "divisions":{
          "data":<Null>[]
        },
        "all_companies":{
          "data":[
            {
              "id":15012,
              "company_name":"Goody",
              "office_email":"zaid@logicielsolutions.co.in",
              "office_additional_email":['2'],
              "office_phone":"1234567900",
              "office_additional_phone":['2'],
              "office_address":"1342 Moneda",
              "office_address_line_1":"",
              "office_fax":"",
              "office_street":null,
              "office_city":"Santiago",
              "office_zip":"51000",
              "office_state_id":1,
              "office_state":{
                "id":1,
                "name":"Alabama",
                "code":"AL",
                "country_id":1
              },
              "office_country_id":1,
              "office_country":{
                "id":1,
                "name":"United States",
                "code":"US",
                "currency_name":"Doller",
                "currency_symbol":"\$",
                "phone_code":"+91"
              },
              "logo":null,
              "created_at":"2022-12-07 12:48:41",
              "account_manager_id":0,
              "subscriber_resource_id":149569,
              "deleted_at":null,
              "phone_format":"(999) 999-9999",
              "license_number":null,
              "signup_origin":"manually"
            }
          ]
        }
      }
    ],
    "status":200
  };
}