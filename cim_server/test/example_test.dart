import 'harness/app.dart';
enum testEnum{e1, e2}
Future main() async {

  final harness = Harness()..install();
  print(testEnum.e1);
  print(testEnum.e2);
  /*test("GET /example returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/example"), 200, body: {"key": "value"});
  });*/
}
