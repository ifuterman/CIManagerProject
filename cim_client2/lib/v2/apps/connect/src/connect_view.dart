import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'connect_view_controller.dart';

class ConnectView extends GetViewSim<ConnectViewController> {
  static const pageTitle = '/Connect';
  static GetPage page = GetPage(
    name: pageTitle,
    page: () => ConnectView(),
    binding: BindingsBuilder.put(() => ConnectViewController()),
  );

  final _controllerAddress = TextEditingController();
  final _controllerPort = TextEditingController();

  Widget getConnectionIcon() {
    switch (c.connectionState$.value) {
      case ConnectionStates.unknown:
        {
          return Icon(
            Icons.contact_support_outlined,
            color: Colors.amberAccent,
          );
        }
      case ConnectionStates.connected:
        {
          return Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
          );
        }
      case ConnectionStates.disconnected:
        {
          return Icon(Icons.cancel, color: Colors.red);
        }
      case ConnectionStates.checking:
        {
          return Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        }
    }
    return Container();
  }

  Widget getUpdatedView(BuildContext context, bool trigger) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "server_address".tr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                width: 200,
                child: Obx((){
                  debugPrint('$now: ConnectionView.getUpdatedView: ${c.updateScreenTrigger}');
                  return TextField(
                    controller: _controllerAddress,
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: false,
                    // enabled: c.connectionState$.value == ConnectionStates.checking,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      c.address = value;
                    },
                  );
                }),
              ),
              Text(
                "server_port".tr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                width: 200,
                child: Obx((){
                  debugPrint('$now: ConnectionView.getUpdatedView: ${c.updateScreenTrigger}');
                  return TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    controller: _controllerPort,
                    // enabled: c.connectionState$.value == ConnectionStates.checking,
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 1,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      c.port = int.parse(value);
                    },
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: Obx(()=>ElevatedButton(
                  child: Text('test_connection'.tr()),
                  onPressed:
                  c.connectionState$.value == ConnectionStates.checking
                      ? c.onCheckConnection
                      : c.onCheckConnection,
                )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: getConnectionIcon(),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=>ElevatedButton(
                child: Text("ok".tr()),
                onPressed: c.connectionState$.value
                    == ConnectionStates.checking  || c.connectionState$.value
                    == ConnectionStates.disconnected
                    ? null
                    : c.applyConnection,
              )),
            ),
            Obx(()=>ElevatedButton(
              child: Text("cancel".tr()),
              onPressed: c.connectionState$.value
                  == ConnectionStates.checking
                  ? null
                  : c.cancelConnection,
            )),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controllerPort.text = c.port.toString();
    _controllerAddress.text = c.address ?? '';
    return SafeArea(
      child: Scaffold(
        body: Container(
          // width: 500,
          child: Obx(
                  () => getUpdatedView(context, c.updateScreenTrigger.value)),
        ),
      ),
    );
  }
}

