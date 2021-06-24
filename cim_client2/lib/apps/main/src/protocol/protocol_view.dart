import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'protocol_view_controller.dart';

class ProtocolView extends GetViewSim<ProtocolViewController> {
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
                '${runtimeType}',
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
