import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'shedule_view_controller.dart';

class SheduleView extends GetViewSim<SheduleViewController> {
  // SheduleView() : super(() => SheduleViewController());

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
