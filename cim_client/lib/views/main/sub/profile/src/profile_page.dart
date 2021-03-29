import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:cim_protocol/cim_protocol.dart';
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
        color: Colors.grey[100],
        child: Center(
          child: Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${c.user$.value.login}'),
              Text('${c.user$.value.role}'),

              SizedBox(height: 30),
              Obx((){
                final items = List.from(c.users$).cast<CIMPatient>();
                return Column(
                children: items.length > 0
                    ? items.map((e) => Text(e.name)).toList() : [Text('')],
              );
              }),
              SizedBox(height: 30),

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
