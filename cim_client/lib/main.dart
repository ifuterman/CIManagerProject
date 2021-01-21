import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/get_view.dart';


import 'package:easy_localization/easy_localization.dart';

void main() {
  int x = 0;
  //runApp(MyApp());
  //Model model = new Model();
  //Controller.initialize(model);
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('ru', 'RU')/*, Locale('de', 'DE')*/],
        path: 'assets/Localizations', // <-- change patch to your
        fallbackLocale: Locale('ru', 'RU'),
        //child: MyApp()
        child: GetMaterialApp(home: CIManagerApp()),
    ),
  );
}
