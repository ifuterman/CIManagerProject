import 'dart:async';
import 'package:liquidart/liquidart.dart';

class CheckConnectionController extends Controller{
  CheckConnectionController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.badRequest();
  }
/*@override
  FutureOr<RequestOrResponse> handle(Request request)  async {
    try {
      await context.persistentStore!.execute(
          "select f_check_connection();");
      return Response.ok("true");
    }catch(e){
      return Response.serverError();
    }
  }*/
}