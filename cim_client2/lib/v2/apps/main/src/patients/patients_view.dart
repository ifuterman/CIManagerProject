import 'package:cim_client2/core/styles/colors.dart';
import 'package:cim_client2/core/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'patients_view_controller.dart';

class PatientsView extends GetViewSim<PatientsViewController> {
  // PatientsView() : super(() => PatientsViewController());

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
                'PATIENTS',
                style: AppStyles.text70.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _TestWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestWidget extends StatefulWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  __TestWidgetState createState() => __TestWidgetState();
}

class __TestWidgetState extends State<_TestWidget> {

  @override
  void initState() {
    super.initState();
    debugPrint('$now: __TestWidgetState.initState');
  }

  @override
  void dispose() {
    debugPrint('$now: __TestWidgetState.dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
