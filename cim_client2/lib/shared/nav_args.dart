/// For navigation
abstract class NavArgs {

  static const defaultKey = 'default';
  static const startNavKey = 'start_navigation';
  //
  static const toNewUser = 'new_user';
  static const toLoginSettings = 'login_settings';

  static safeValue<T>(Map<String, dynamic>? args, {String? key, defValue}){
    if(args == null){
      return null;
    }

    key ??= defaultKey;
    if(args.containsKey(key)){
      return args[key] as T;
    }
    return defValue;
  }

  static Map<String, dynamic> simple(value) => {defaultKey: value};
}
