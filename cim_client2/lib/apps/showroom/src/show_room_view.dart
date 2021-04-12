import 'package:cim_client2/apps/showroom/src/show_room_view_controller.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:cim_client2/core/extensions.dart';

///
class ShowRoomView extends AppGetView<ShowRoomViewController>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: AppColors.mainBG,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: c.splashState,
                child: Text('splash'),
              ),
              10.h(),
              ElevatedButton(
                onPressed: c.homeState,
                child: Text('home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
