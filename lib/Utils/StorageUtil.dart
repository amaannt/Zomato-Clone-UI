
import 'package:shared_preferences/shared_preferences.dart';
class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;
  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  // put string
  static Future<bool> putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }
  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }
  static clrString() {
    SharedPreferences prefs = _preferences;
    prefs.clear();
  }
  static Future<bool> putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }
  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return null;
    return _preferences.getBool(key) ?? defValue;
  }
  static Future<bool> putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences.setInt(key, value);
  }
  static int getInt(String key, {int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences.getInt(key) ?? defValue;
  }

}