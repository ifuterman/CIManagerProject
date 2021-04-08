import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/data/provider/data_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'core/routes.dart';
import 'core/services/connection_service.dart';
import 'core/services/global_service.dart';
import 'data/provider/cache_provider.dart';

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
      initialRoute: GlobalService.initialRoute,
      getPages: routes,
    );
  }
}


Future initServices() async {
  Get.lazyPut(() => GlobalService());
  Get.lazyPut<DataProvider>(() => DataProviderImpl());
  Get.lazyPut<CacheProvider>(() => CacheProviderImpl());
  Get.lazyPut(() => ConnectionService());

  // immediately
  Get.find<GlobalService>();
}