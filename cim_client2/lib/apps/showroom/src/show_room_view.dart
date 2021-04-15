import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:cim_client2/core/extensions.dart';

import 'show_room_view_controller.dart' as ctrl;

///
class ShowRoomView extends AppGetView<ctrl.ShowRoomViewController>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: AppColors.mainBG,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: c.splashState,
                icon: ctrl.State.splash.icon,
                label: Text('splash'),
              ),
              10.h(),
              ElevatedButton.icon(
                onPressed: c.homeState,
                icon: ctrl.State.home.icon,
                label: Text('home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
