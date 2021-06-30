import 'package:cim_client2/core/services/global_view_service.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/data/cache_provider.dart';
import 'package:cim_client2/data/data_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'core/services/cim_service.dart';
import 'core/services/data_service.dart';
import 'routing/routing.dart';

Future main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await initServices();

  runApp(
    EasyLocalization(
      saveLocale: false,
      supportedLocales: const <Locale>[
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateTitle: (_) => 'title'.tr(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: AppColors.mainBG,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: Get.key,
      initialRoute: GlobalViewService.initialRoute,
      getPages: routes,
    );
  }
}


Future initServices() async {
  Get.put(GlobalViewService());

  Get.lazyPut<DataService>(() => DataService());
  final cache = await Get.putAsync<CacheProviderService>(() => CacheProviderService().init());
  Get.put<DataProvider>(DataProviderImpl());
  await Get.putAsync(() => CIMService().init());

  // Get.lazyPut<CacheProvider>(() => CacheProviderImpl());
  // Get.lazyPut(() => ConnectionService());
  //
  // // immediately
  // Get.find<GlobalService>();
}