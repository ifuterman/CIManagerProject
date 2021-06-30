import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'splash_view_controller.dart';

class SplashView extends GetViewSim<SplashViewController> {
  static const pageTitle = '/Splash';
  static GetPage page = GetPage(
    name: pageTitle,
    page: () => SplashView(),
    binding: BindingsBuilder.put(() => SplashViewController()),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.mainBG,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CIM',
                style: AppStyles.text70.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
