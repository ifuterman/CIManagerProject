import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_page_controller.dart';

class ProfilePage extends AppGetView<ProfilePageController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => c.subWidgetPlacer$.value);
  }
}


class ProfileSubView extends AppGetView<ProfilePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[200],
        child: Center(
          child: Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${c.user$.value.login}'),
              Text('${c.user$.value.role}'),
              ElevatedButton(
                onPressed: c.makeUser,
                child: Text('Make User'),
              ),
            ],
          )) ,
        ),
      ),
    );
  }
}
