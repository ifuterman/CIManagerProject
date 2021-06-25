import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// Разнообразные правильно именованные ключи для карты аргументов
abstract class MapKeys{
  /// Определяет булевое значение для свойства [GetxController.tag]
  static const controllerTag = 'controller.tag';
  /// Определяет булевое значение для свойства [GetxController.permanent]
  static const controllerPermanent = 'controller.permanent';
}

/// Хелпер кастинга аргументов в карту и поиска значения по ключу.
T? castToMapAndFind<T>(args, String key, {T? defValue}){
  if(args == null || args is! Map<String, dynamic>){
    return defValue;
  }
  if(!args.containsKey(key)){
    return defValue;
  }
  return args[key] as T;
}

/// Хелпер поиска значения по ключу.
T? fromMapEntry<T>(Map<String, dynamic> map, String key, {T? defValue}){
  if(!map.containsKey(key)){
    return defValue;
  }
  return map[key] as T;
}