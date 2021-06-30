import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'profile_view_controller.dart';

class ProfileView extends GetViewSim<ProfileViewController> {

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
                'SHEDULE',
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
