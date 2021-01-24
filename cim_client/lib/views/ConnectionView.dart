
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ConnectionViewController.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ConnectionView extends StatelessWidget {
  final ConnectionViewController controller = Get.put(ConnectionViewController());
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPort = TextEditingController();

  ConnectionView(){
    controller.init();
  }

  Widget getConnectionIcon() {
    switch (controller.connectionState) {
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
          return Icon(
              Icons.cancel,
              color: Colors.red
          );
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
    return null;
  }

  Widget getUpdatedView(BuildContext context, bool trigger) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SERVER_ADDRESS".tr(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
            Container(
              constraints: BoxConstraints.expand(
                  height: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .fontSize *
                      1.2,
                  width: Theme
                      .of(context)
                      .textTheme
                      .bodyText1
                      .fontSize *
                      15),
              child: TextField(
                controller: _controllerAddress,
                textAlignVertical: TextAlignVertical.top,
                obscureText: false,
                enabled: controller.connectionState ==
                    ConnectionStates.checking ? false : true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.address = value;
                },
              ),
            ),
            Text(
              "SERVER_PORT".tr(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
            Container(
              constraints: BoxConstraints.expand(
                  height: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .fontSize *
                      1.2,
                  width:
                  Theme
                      .of(context)
                      .textTheme
                      .bodyText1
                      .fontSize * 8),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                controller: _controllerPort,
                enabled: controller.connectionState ==
                    ConnectionStates.checking ? false : true,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 1,
                obscureText: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.port = int.parse(value);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: ElevatedButton(
                child: Text("TEST_CONNECTION".tr()),
                onPressed: controller.connectionState == ConnectionStates.checking ? null : controller.onCheckConnection,
              ),
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
            child: ElevatedButton(
              child: Text("OK".tr()),
              onPressed: controller.connectionState == ConnectionStates.checking ? null : controller.applyConnection,
            ),
          ),
          ElevatedButton(
            child: Text("CANCEL".tr()),
            onPressed: controller.connectionState == ConnectionStates.checking ? null : controller.cancelConnection,
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _controllerPort.text = controller.port.toString();
    _controllerAddress.text = controller.address;
    return Container(
      child: Obx(
              () =>
              getUpdatedView(context, controller.updateScreenTrigger.value)

      ),
    );
  }
}

