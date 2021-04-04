import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/data/cim_errors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'home_view_controller.dart';

class HomeView extends AppGetView<HomeViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(c.title$())),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Obx(()=>c.connectionResult$().cimErrors == CIMErrors.initial
                ? CircularProgressIndicator()
                : Container(child: Text('${c.connectionResult$()}'),) ),
            Obx(() {
              debugPrint('$now: HomeView.build: title = ${c.title$()}');
              return Text(
                c.title$(),
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => c.changeTitle('title'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
