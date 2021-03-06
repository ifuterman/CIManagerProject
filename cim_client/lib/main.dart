import 'package:cim_client/cim_service.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/pref_service.dart';
import 'package:cim_client/views/auth/authorization_view_controller.dart';
import 'package:cim_client/views/global_view_service.dart';
import 'package:cim_client/views/shared/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vfx_flutter_common/utils.dart';


void main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await initServices();
  final pref = Get.find<PreferenceService>();
  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('ru'),
      ],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: const Locale('ru'),
      child: StreamBuilder<bool?>(
          initialData: pref.isDarkMode$.value,
          stream: pref.isDarkMode$.stream,
          builder: (context, snapshot) {
            final isDark = snapshot.data;
            return GetMaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: (isDark ?? false) ? Brightness.dark : Brightness.light,
              ),
              // home: CIMApp(),
              navigatorKey: Get.key,
              initialRoute: GlobalViewService.initialRoute,
              getPages: routes,

              // enableLog: true,
              // logWriterCallback: Logger.write,

            );
          }),
    ),
  );
}

Future initServices() async {
  print('starting services ...');
  // await GetStorage.init();
  final cache = await Get.putAsync<CacheProviderService>(() => CacheProviderService().init());
  Get.put<DataProvider>(DataProviderImpl());
  await Get.putAsync(() => PreferenceService(cache).init());
  await Get.putAsync(() => CIMService().init());
  await Get.putAsync(() => GlobalViewService().init());
  // await Get.putAsync(() => AuthorizationViewController().init());
  // await delayMilli(1000);
  print('All services started...');
}
