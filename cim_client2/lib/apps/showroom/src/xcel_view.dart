import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cim_client2/core/extensions.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';

import 'xcel_view_controller.dart';

///
class XcelView extends AppGetView<XcelViewController>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('EXCEL'),
              Column(
                children: List.generate(5, (index) => Container()),
              ),
              Obx(() {
                final height = c.page$().height;
                final width = c.page$().width;
                debugPrint('$now: ExcelView.build: w = $width, h = $height');
                return Row(
                  children: List.generate(width, (w){
                    return Column(
                      children: List.generate(height, (h){
                        final row = c.page$().whole[h];
                        final value = row.data[w];
                        return Text('$value');
                      }),
                    );
                  }),
                );
              }),
              ElevatedButton(
                onPressed: c.close,
                child: Text('back'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
