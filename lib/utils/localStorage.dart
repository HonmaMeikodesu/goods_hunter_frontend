import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<SharedPreferences> getInstance(){
    return SharedPreferences.getInstance();
  }

  static void set<T>({ required String key, required T value }) async {
    await getInstance().then((instance) async {
      Map<Type, dynamic> allowedTypesMap = {
        int: instance.setInt,
        bool: instance.setBool,
        double: instance.setDouble,
        String: instance.setString,
        List<String>: instance.setStringList,
      };
      if(!allowedTypesMap.keys.contains(T)) {
        throw Exception("Unsupported type!");
      }
      await allowedTypesMap[T]!(key, value);
    });
  }

  static Future<T> get<T>({ required String key }) async {
    return await getInstance().then((instance) async {
      Map<Type, dynamic> allowedTypesMap = {
        int: instance.getInt,
        bool: instance.getBool,
        double: instance.getDouble,
        String: instance.getString,
        List<String>: instance.getStringList,
      };
      if(!allowedTypesMap.keys.contains(T)) {
        throw Exception("Unsupported type!");
      }
      return await allowedTypesMap[T]!(key);
    });
  }
}