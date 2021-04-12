import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:cim_client2/core/extensions.dart';

import 'show_room_view_controller.dart';

///
class HomeView extends AppGetView<ShowRoomViewController>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: AppColors.mainBG,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$runtimeType'),
              10.h(),
              ElevatedButton(
                onPressed: c.back,
                child: Text('home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
