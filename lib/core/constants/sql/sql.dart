class SqlConstants {
  /// this constent is use for relation query(join)
  static const Map<String, dynamic> userKeys = {
    "all": {
      'integer': [
        'id',
        'group_id',
        'company_id',
        'active',
        'resource_id',
        'all_divisions_access'
      ],
      'string': [
        'first_name',
        'last_name',
        'full_name',
        'email',
        'group_name',
        'profile_pic',
        'sub_company_name',
        'color',
      ]
    }
  };
  /// this constent is use for relation query(join)
  static const Map<String, dynamic> tagKeys = {
    "all": {
      'integer': [
        'id',
        'company_id'
      ],
      'string': [
        'name',
        'type'
      ]
    }
  };
  /// this constent is use for relation query(join)
  static const Map<String, dynamic> workTypeKeys = {
    "all": {
      'integer': [
        'id',
        'trade_id',
        'company_id',
        'active',
      ],
      'string': [
        'name',
        'color',
      ]
    }
  };
  /// this constent is use for relation query(join)
  static const Map<String, dynamic> divisionKeys = {
    "all": {
      'integer': [
        'id',
        'company_id'
      ],
      'string': [
        'code',
        'color',
        'email',
        'name',
        'phone',
        'phone_ext'
      ]
    }
  };
}
