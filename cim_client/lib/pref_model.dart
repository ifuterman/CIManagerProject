import 'package:cim_client/shared/model_helpers.dart';

class Pref{
  final onDarkModeSwitched = BehaviorSubjectHelper.seeded(false);
  void switchDarkMode(){
    onDarkModeSwitched.add(!onDarkModeSwitched.value);
  }
}

// ignore: non_constant_identifier_names
final ThePref = Pref();