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
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${c.user$.value.login}'),
                  Text('${c.user$.value.role}'),
                  SizedBox(height: 30),
                  Obx(() {
                    final items = List.from(c.users$).cast<CIMPatient>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: items.length > 0
                          ? items.map((e) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(e.name),
                                  Text(e.sex.toString()),
                                ],
                              );
                            }).toList()
                          : [Text('')],
                    );
                  }),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: c.makeUser,
                    child: Text('Make User'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.id,
    required this.name,
    this.middleName,
    required this.lastName,
    this.birthDate,
    this.phones,
    this.email,
    this.snils,
    required this.status,
    required this.sex,
    Key? key,
  }) : super(key: key);

  final int id;
  final String name;
  final String? middleName;
  final String lastName;
  final DateTime? birthDate;
  final String? phones;
  final String? email;
  final String? snils;

  final Participation status;

  final Sex sex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(''),
        SizedBox(width: 10),
        Text(''),
      ],
    );
  }
}

// int id;
// String name;
// String? middleName;
// String lastName;
// DateTime? birthDate;
// String? phones;
// String? email;
// String? snils;
// Participation status;
// Sex sex;
