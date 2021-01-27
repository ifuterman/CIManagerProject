import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/cim_app.dart';

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ru', 'RU') /*, Locale('de', 'DE')*/
      ],
      path: 'assets/Localizations', // <-- change patch to your
      fallbackLocale: Locale('ru', 'RU'),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: CIMApp(),
      ),
    ),
  );
}
