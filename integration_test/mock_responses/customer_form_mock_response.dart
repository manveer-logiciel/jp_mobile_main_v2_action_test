
class CustomerFormMockResponse {

  static const Map<String, dynamic> okResponseAddCustomer = {
    "message": "Prospect / Customer saved successfully.",
    "customer": {
      "id": 46372,
      "company_name": "Logiciel Solutions",
      "address_id": 270251,
      "billing_address_id": 270251,
      "first_name": "Manveer",
      "last_name": "Singh",
      "full_name": "Manveer Singh",
      "full_name_mobile": "Manveer Singh",
      "email": "",
      "source_type": null,
      "additional_emails": <dynamic>[],
      "rep_id": null,
      "distance": null,
      "referred_by_type": "",
      "referred_by_note": "",
      "jobs_count": null,
      "total_jobs_count": 0,
      "call_required": false,
      "appointment_required": false,
      "note": "",
      "is_commercial": 0,
      "created_at": "2023-10-05 07:23:21",
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
        "id": 270251,
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
        "geocoding_error": 0,
        "created_by": 1229,
        "updated_by": 1229,
        "update_origin": null,
        "updated_from": null,
        "device_uuid": null,
        "created_at": "2023-10-05 07:23:21",
        "updated_at": "2023-10-05 07:23:21"
      },
      "phones": {
        "data": [
          {
            "label": "cell",
            "number": "4444444444",
            "ext": ""
          }
        ]
      },
      "billing": {
        "id": 270251,
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
        "geocoding_error": 0,
        "created_by": 1229,
        "updated_by": 1229,
        "update_origin": null,
        "updated_from": null,
        "device_uuid": null,
        "created_at": "2023-10-05 07:23:21",
        "updated_at": "2023-10-05 07:23:21"
      }
    },
    "status": 200
  };

  static const Map<String, dynamic> companySettingsWithRequiredFields = {
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "company_id": 15395,
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "false"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "false"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "false"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "false"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "false"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "false"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "false"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "false"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "false"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "false"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "false"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "false"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "false"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "false"
        }
      ],
    },
    "id": 7190
  };

  static const Map<String, dynamic> companySettingsWithShuffledFields = {
    "id": 7190,
    "company_id": "15395",
    "user_id": null,
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "true"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "true"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "true"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "true"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "true"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "true"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "true"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "true"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "true"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "true"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "true"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "true"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "true"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "true"
        }
      ],
    }
  };

  static const Map<String, dynamic> companySettingsWithLimitedFields = {
    "id": 7190,
    "company_id": "15395",
    "user_id": null,
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "false"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "false"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "true"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "false"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "false"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "false"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "true"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "true"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "true"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "true"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "true"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "true"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "false"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "true"
        }
      ],
    }
  };

  static const Map<String, dynamic> companySettingsWithLimitedSections = {
    "id": 7190,
    "company_id": "15395",
    "user_id": null,
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "false"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "false"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "true"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "false"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "false"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "false"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "true"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "true"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "true"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "false"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "false"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "false"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "false"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "false"
        }
      ],
    }
  };

  static const Map<String, dynamic> companySettingsWithOneSection = {
    "id": 7190,
    "company_id": "15395",
    "user_id": null,
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "false"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "false"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "true"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "false"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "false"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "false"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "false"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "true"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "false"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "false"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "false"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "false"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "false"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "false"
        }
      ],
    }
  };

  static const Map<String, dynamic> companySettingsWithTwoSection = {
    "id": 7190,
    "company_id": "15395",
    "user_id": null,
    "key": "PROSPECT_CUSTOMIZE",
    "name": "PROSPECT_CUSTOMIZE",
    "value": {
      "CUSTOMER": [
        {
          "key": "customer_name",
          "name": "Customer / Company Name",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "commercial_customer_name",
          "name": "Customer Name",
          "showField": "false"
        },
        {
          "key": "company_name",
          "name": "Company Name",
          "showField": "false"
        },
        {
          "key": "salesman_customer_rep",
          "name": "Salesman / Customer Rep",
          "showField": "true"
        },
        {
          "key": "customer_note",
          "name": "Customer Note",
          "showField": "false"
        },
        {
          "key": "referred_by",
          "name": "Referred By",
          "showField": "false"
        },
        {
          "key": "property_name",
          "name": "Property Name",
          "showField": "false"
        },
        {
          "key": "phone",
          "name": "Phone",
          "required": "true",
          "showField": "true"
        },
        {
          "key": "custom_fields",
          "name": "Custom Fields",
          "showField": "true"
        },
        {
          "key": "qb_online",
          "name": "Sync with QuickBooks Online / Desktop",
          "showField": "true"
        },
        {
          "key": "customer_address",
          "name": "Customer Address",
          "showField": "false"
        },
        {
          "key": "other_information",
          "name": "Other Information",
          "showField": "false"
        },
        {
          "key": "canvasser",
          "name": "Canvasser",
          "showField": "false"
        },
        {
          "key": "email",
          "name": "Email",
          "showField": "false"
        },
        {
          "key": "call_center_rep",
          "name": "Call Center Rep",
          "showField": "false"
        },
        {
          "key": "management_company",
          "name": "Management Company",
          "showField": "false"
        }
      ],
    }
  };
}