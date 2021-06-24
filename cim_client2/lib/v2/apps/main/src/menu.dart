import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';

import 'main_view_controller.dart';

class MainMenu extends GetViewSim<MainViewController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => getMenu(c.selectedItem$()));
  }

  Widget getMenu(MenuItem selected) {
    return ListView(
      children: [
        ListTileItem(
          selected: selected == MenuItem.patients,
          title: 'patient_list'.tr(),
          onTap: () => c.openSub(MenuItem.patients, args: {
            'permanent': true,
          }),
        ),
        ListTileItem(
          selected: selected == MenuItem.schedule,
          title: 'schedule'.tr(),
          onTap: () => c.openSub(MenuItem.schedule),
        ),
        ListTileItem(
          selected: selected == MenuItem.protocol,
          title: 'protocols'.tr(),
          onTap: () => c.openSub(MenuItem.protocol),
        ),
        SizedBox(height: 100),
        ListTileItem(
          selected: selected == MenuItem.profile,
          title: 'profile'.tr(),
          onTap: () => c.openSub(MenuItem.profile),
        ),
        Container(
          height: 100,
        ),
        if (kDebugMode)
          ListTileItem(
            selected: selected == MenuItem.messages,
            title: 'Clear User',
            onTap: () {},
          ),
      ],
    );
  }
}


class ListTileItem extends GetViewSim<MainViewController> {
  const ListTileItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

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
