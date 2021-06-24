import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'main_view_controller.dart';
import 'menu.dart';

class MainView extends GetViewSim<MainViewController> {
  static const pageTitle = '/Main';
  static GetPage page = GetPage(
    name: pageTitle,
    page: () => MainView(),
    binding: BindingsBuilder.put(() => MainViewController()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: MainPanel(),
          ),
        ],
      ),
    );
  }
}

class MainPanel extends GetViewSim<MainViewController> {
  @override
  Widget build(context) => Obx(() => c.subWidgetPlacer$());
}
