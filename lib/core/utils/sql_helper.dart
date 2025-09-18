class SqlHelper {
  /// this function is creating a group cancat query's section
  /// for getting relational data from other tables
  static String getGroupConcatQuery(String type, dynamic keys) {
    String query = '''
      ,('['|| GROUP_CONCAT('{'
    ''';

    for (var i = 0; i < keys['integer'].length; i++) {
      if(keys['integer'][i] == 'id') {
        query += '''
          || '"${keys['integer'][i]}":' ||  $type.${keys['integer'][i]}
        ''';
      } else {
        query += '''
          || '"${keys['integer'][i]}":' || coalesce($type.${keys['integer'][i]}, 'null')
        ''';
      }

      if(keys['integer'].length != i+1) {
        query += '''
          || ','
        ''';
      }
    }

    if (keys['string'].length > 0) {
      query += '''
          || ','
        ''';

      for (int i = 0; i < keys['string'].length; i++) {
        query += '''
          || '"${keys['string'][i]}":' || COALESCE('"' || REPLACE(REPLACE($type.${keys['string'][i]}, "\\", "\\\\"), '"', '\\"') || '"', 'null') || ''
        ''';

        if(keys['string'].length != i+1) {
          query += '''
            || ','
          ''';
        }
      }
    }
    
    query += '''
      || '}', ',') || ']') AS $type
    ''';

    return query;
  }

}