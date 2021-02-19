import 'package:cim_client/views/shared/styles/fonts.dart';
import 'package:cim_client/views/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[100],
        child: Center(
          child: Text('CIM', style: AppStyles.text70.copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
