import 'package:cim_client/views/profile/profile_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfilePageController> {
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      body: Container(
        color: Colors.green[100],
        child: Center(
          child: ElevatedButton(
            onPressed: c.close,
            child: Text('close'),
          ),
        ),
      ),
    );
  }
}
