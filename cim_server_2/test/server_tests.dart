


import 'package:test/test.dart';

enum TestEnum{
  v1, v2
}

void test_system() async{

  dynamic r;
  r = 'v1';
  print(r);
  if(r is String){
    r = TestEnum.v1;
  }
  print(r);
}


void main (){
  group('server test', (){
    test('test config.yaml',(){
      test_system();
    });
  });
}