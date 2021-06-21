import 'package:cim_client2/core/getx_helpers.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

import 'xcel_view_controller.dart';

///
class XcelView extends AppGetView<XcelViewController> {
  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width;
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
                final rowCount = c.page$().rowCount;
                final colCount = c.page$().columnCount;
                final gap = 2.0;
                final colWidth = (totalWidth / colCount) - gap * 2;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(colCount, (cc) {
                    return Column(
                      children: List.generate(rowCount, (rc) {
                        final row = c.page$().whole[rc];
                        final value = row.data[cc];
                        return Container(
                          padding: EdgeInsets.all(2),
                          color: rc!=0? Colors.white: Colors.black54,
                          width: colWidth,
                          child: Text(
                            '$value',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: rc==0? Colors.white: Colors.black),
                          ),
                        );
                      }),
                    );
                  }),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: c.rowDown,
                    child: Text('prev row'),
                  ),
                  ElevatedButton(
                    onPressed: c.rowUp,
                    child: Text('next row'),
                  ),
                  ElevatedButton(
                    onPressed: c.colDown,
                    child: Text('prev column'),
                  ),
                  ElevatedButton(
                    onPressed: c.colUp,
                    child: Text('next column'),
                  ),
                ],
              ),
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
