import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorization_view_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'main_view_controller.dart';

class MainView extends GetView<MainViewController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('$now: MainView.build: BACK');
        return controller.close();
      },
      child: Scaffold(
        body: Row(
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
        ),
      ),
    );
  }
}

class _ListTileItem extends GetView<MainViewController> {
  _ListTileItem({this.item, this.title, this.selected, this.onTap});

  final MainMenuItems item;
  final String title;
  final bool selected;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: Material(
        color: selected ? Colors.blue : Colors.black,
        textStyle: TextStyle(color: Colors.white),
        child: ListTile(
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            hoverColor: Colors.blue,
            onTap: onTap),
      ),
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
        _ListTileItem(
          selected: selected == MainMenuItems.item_patients,
          title: 'patient_list'.tr(),
          onTap: () => controller.openSub(MainMenuItems.item_patients),
        ),
        _ListTileItem(
          selected: selected == MainMenuItems.item_schedule,
          title: 'schedule'.tr(),
          onTap: () => controller.openSub(MainMenuItems.item_schedule),
        ),
        _ListTileItem(
          selected: selected == MainMenuItems.item_protocol,
          title: 'protocols'.tr(),
          onTap: () => controller.openSub(MainMenuItems.item_protocol),
        ),
        Container(
          height: 100,
        ),
        if (kDebugMode)
          _ListTileItem(
            selected: selected == MainMenuItems.item_messages,
            title: 'Clear User',
            onTap: () {
              delayMilli(10).then((_) => controller.close());
              Get.put<AuthorizationViewController>(AuthorizationViewController()
                ..pageNavigate());
            },
          ),
      ],
    );
  }
}

class MainScreen extends GetView<MainViewController> {
  @override
  Widget build(context) => Obx(() => controller.subWidgetPlacer$.value);
}
