import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';

import 'splash_view_controller.dart';

class SplashView extends AppGetView<SplashViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.mainBG,
        child: Center(
          child: Text(
            'CIM',
            style: AppStyles.text70.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
