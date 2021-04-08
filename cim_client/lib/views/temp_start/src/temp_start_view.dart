import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:cim_client/views/temp_start/src/temp_start_view_controller.dart';
import 'package:flutter/material.dart';

class TempStartView extends AppGetView<TempStartViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(child: Text('AAA'),),
              Container(
                width: 200,
                child: TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
