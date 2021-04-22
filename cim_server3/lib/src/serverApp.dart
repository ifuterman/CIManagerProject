import 'package:liquidart/liquidart.dart';
import 'package:liquidart/src/http/controller.dart';

class ServerApp extends ApplicationChannel{

  @override
  Future prepare() async{
  }

  @override
  // TODO: implement entryPoint
  Controller get entryPoint => throw UnimplementedError();
}