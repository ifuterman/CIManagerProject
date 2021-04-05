import 'package:cim_client2/apps/excel/src/excel_view_controller.dart';
import 'package:cim_client2/core/getx_helpers.dart';
import 'package:flutter/material.dart';

class ExcelView extends AppGetView<ExcelViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: c.close,
            child: Text('BACK'),
          ),
        ),
      ),
    );
  }
}
