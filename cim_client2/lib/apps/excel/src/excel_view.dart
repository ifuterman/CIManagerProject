import 'package:cim_client2/apps/excel/src/excel_view_controller.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/utils.dart';

class ExcelView extends AppGetView<ExcelViewController> {
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
                final rowCount = c.data$().rowCount;
                return Column(
                    children: List.generate(rowCount, (i) {
                  final row = c.data$().data[i];
                  final colCount = c.data$().columnCount;
                  return Row(
                    children: List.generate(colCount, (j) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Text('${row.data.values.toList()[j]}'),
                      );
                    }),
                  );
                }));
              }),
              ElevatedButton(
                onPressed: c.close,
                child: Text('BACK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
