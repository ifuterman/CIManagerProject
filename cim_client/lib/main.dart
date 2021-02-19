import 'package:cim_client/cim_service.dart';
import 'package:cim_client/views/global_view_service.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'views/cim_app.dart';

void main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ru', 'RU') /*, Locale('de', 'DE')*/
      ],
      path: 'assets/Localizations', // <-- change patch to your
      fallbackLocale: Locale('ru', 'RU'),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // home: CIMApp(),
        navigatorKey: Get.key,
        initialRoute: GlobalViewService.initialRoute,
        getPages: routes,
      ),
    ),
  );
}

Future initServices() async {
  print('starting services ...');
  await GetStorage.init();
  Get.lazyPut(() => CIMService());
  Get.putAsync(() => GlobalViewService().init());
  print('All services started...');
}
