import 'package:cim_client/views/authorisation_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:cim_client/cim_service.dart';

class AuthorisationView extends StatelessWidget {
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();
  final controller = Get.put(AuthorisationViewController());
//  final Controller controller = Get.find();
  final CIMService service = Get.find();

  @override
  Widget build(BuildContext context) {
    _controllerLogin.text = controller.user.login;
    return Align(
//          alignment: Alignment.topLeft,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'USERAUTHORIZATIONSCREEN_USERNAME_TITLE'.tr(),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.right,
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.headline6.fontSize * 1.2,
                width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
            child: TextField(
              controller: _controllerLogin,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.user.login = _controllerLogin.text;
              },
            ),
          ),
          Text(
            'USERAUTHORIZATIONSCREEN_PASSWORD_TITLE'.tr(),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.right,
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.headline6.fontSize * 1.2,
                width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
            child: TextField(
              controller: _controllerPassword,
              textAlignVertical: TextAlignVertical.top,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            child: Text("USERAUTHORIZATIONSCREEN_BUTTON_AUTHORIZE_TITLE".tr()),
            onPressed: () {
              controller.user.password = _controllerPassword.text;
              controller.user.login = _controllerLogin.text;
              controller.authoriseUser();
/*              if (controller.isAuthorised())
                service.currentView.value = CIMViews.main_view;*/
            },
//              onPressed: () => viewModel.authorizeUser(),
          ),
          TextButton(
            child: Text(
              "CONNECTION_OPTIONS".tr(),
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              service.currentView.value = CIMViews.connectionView;
            },
          )
        ],
      ),
    );
  }
}