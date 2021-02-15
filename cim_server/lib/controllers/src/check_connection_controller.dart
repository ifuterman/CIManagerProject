import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class CheckConnectionController extends Controller{
  CheckConnectionController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle(Request request)  async {
    try {
      await context.persistentStore.execute(
          "select f_check_connection();");
      return Response.ok("true");
    }catch(e){
      return Response.serverError();
    }
  }
}