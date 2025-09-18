class CreateCompanyContactMockResponse {

  static const Map<String,dynamic> okResponse = {
    "data": {
      "id": 156,
      "first_name": "Veer",
      "last_name": "Singh",
      "full_name": "Veer Singh",
      "full_name_mobile": "Veer Singh",
      "company_name": "Test",
      "created_at": "2020-11-06 06:48:30",
      "updated_at": "2020-11-06 06:48:30",
      "is_prime_contractor": 0,
      "address": {
        "id": 167703,
        "address": "722, Tamarack Way Northwest",
        "address_line_1": "chowk",
        "city": "Edmonton",
        "state_id": 53,
        "state": {
          "id": 53,
          "name": "Alberta",
          "code": "AB",
          "country_id": 4
        },
        "country_id": 4,
        "country": {
          "id": 4,
          "name": "Canada",
          "code": "CA",
          "currency_name": "Doller",
          "currency_symbol": "\$",
          "phone_code": "+91"
        },
        "zip": "T6T 1H9",
        "lat": null,
        "long": null,
        "geocoding_error": 1,
        "created_by": null,
        "updated_by": null,
        "update_origin": null,
        "updated_from": null,
        "device_uuid": null,
        "created_at": "2023-04-06 10:09:15",
        "updated_at": "2023-04-12 12:39:16"
      },
      "note": "notes test",
      "phones": {
        "data": [
          {
            "id": 119209,
            "label": "cell",
            "number": "9876543210",
            "ext": "12",
            "is_primary": 1
          }
        ]
      },
      "emails": {
        "data": [
          {
            "id": 1092,
            "email": "veer@gmail.com",
            "is_primary": 1
          }
        ]
      },
      "tags": {
        "data": [
          {
            "id": 20,
            "name": "vendor",
            "type": "contact",
            "updated_at": "2020-09-09 10:20:49",
          },
        ],
      },
    },
    "status": 200,
  };
}