import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'main_view_controller.dart';
import '../patient_screen.dart';

class MainView extends StatelessWidget {
  final controller = Get.put(MainViewController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black,
            child: MainMenu(),
          ),
        ),
        Expanded(
          flex: 4,
          child: MainScreen(),
        ),
      ],
    );
  }
}

class MainMenu extends StatelessWidget {
  final controller = Get.find<MainViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => getMenu(controller.selectedItem.value));
  }

  Widget getMenu(MainMenuItems selected) {
    return ListView(
      children: [
        ListTileTheme(
          child: Material(
            color: selected == MainMenuItems.item_patients
                ? Colors.blue
                : Colors.black,
            textStyle: TextStyle(color: Colors.white),
            child: ListTile(
                title: Text(
                  'MAINVIEWLEFTLIST_ITEM_PATIENTSLIST_TITLE'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
                hoverColor: Colors.blue,
                onTap: () => controller
                    .onSelectMainMenuItem(MainMenuItems.item_patients)),
          ),
        ),
        ListTileTheme(
          child: Material(
            color: selected == MainMenuItems.item_schedule
                ? Colors.blue
                : Colors.black,
            textStyle: TextStyle(color: Colors.white),
            child: ListTile(
                title: Text(
                  'MAINVIEWLEFTLIST_ITEM_SCHEDULE_TITLE'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
                hoverColor: Colors.blue,
                onTap: () => controller
                    .onSelectMainMenuItem(MainMenuItems.item_schedule)),
          ),
        ),
        ListTileTheme(
          child: Material(
            color: selected == MainMenuItems.item_protocol
                ? Colors.blue
                : Colors.black,
            textStyle: TextStyle(color: Colors.white),
            child: ListTile(
                title: Text(
                  'MAINVIEWLEFTLIST_ITEM_PROTOCOLS_TITLE'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
                hoverColor: Colors.blue,
                onTap: () => controller
                    .onSelectMainMenuItem(MainMenuItems.item_protocol)),
          ),
        ),
      ],
    );
  }
}

class MainScreen extends StatelessWidget {
  final controller = Get.find<MainViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => getScreen(controller.selectedItem.value));
  }

  Widget getScreen(MainMenuItems item) {
    switch (item) {
      case MainMenuItems.item_patients:
        {
          return PatientScreen();
        }
      default:
        return Container();
    }
  }
}
