import 'package:cim_excel/cim_excel.dart';
import 'package:cim_shared/cim_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      navigatorKey: Get.key,
      initialRoute: '/',
      getPages: routes,
    );
  }
}

final List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => MyHomePage(),
    transition: Transition.fadeIn,
    binding: BindingsBuilder.put(() => MyHomePageController('Hello')),
  ),
];

class MyHomePageController extends GetxController {
  MyHomePageController(this.title);

  final excel = CIMExcel;

  final String title;
  final counter$ = 0.obs;

  final openResult$ = ''.obs;

  void openFile() {
    final res = excel.open('path');
    openResult$(res.result);
    delayMilli(2000).then((_) => openResult$(''));
  }
}

class MyHomePage extends GetView<MyHomePageController> {
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(c.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Obx(
              () => Text(
                '${c.counter$.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            TextButton(
              onPressed: c.openFile,
              child: Text('Open excel file'),
            ),
            Obx(()=>Text('${c.openResult$}')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => c.counter$.value++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
