import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefService {

  List<String> preservableKeys = [
    PrefConstants.isURMigrated,
    PrefConstants.isUploadTableMigrated,
    PrefConstants.devConsole,
    PrefConstants.deviceLanguage,
  ];

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) != null
        ? json.decode(prefs.getString(key)!)
        : null;
  }

  save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    final preservedData = await getPreservedData(prefs);
    await prefs.clear();
    savePreservedData(prefs, preservedData);
    await Helper.setApplicationBadgeCount('0');
  }

  Future<Map<String, dynamic>> getPreservedData(SharedPreferences prefs) async {
    Map<String, dynamic> preservedData = {};
    for (var key in preservableKeys) {
      preservedData[key] = await read(key);
    }
    return preservedData;
  }

  Future<void> savePreservedData(SharedPreferences prefs, Map<String, dynamic> preservedData) async {
    for (var key in preservedData.keys) {
      await save(key, preservedData[key]);
    }
  }
}
