import 'package:cim_client/cim_service.dart';
import 'package:cim_client/pref_service.dart';
import 'package:cim_client/views/auth/authorisation_view_controller.dart';
import 'package:cim_client/views/shared/ui_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class AuthorisationView extends GetView<AuthorisationViewController> {

  final pref = Get.find<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DebuggableWidget(
          mainWidget: _MainWidget(),
          debugItems: {
            'change theme': pref.switchDarkMode,
            'DEBUG MENU #1': () {},
          },
          top: 5,
        ),
      ),
    );
  }
}

class _MainWidget extends GetView<AuthorisationViewController> {
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();

  // final controller = Get.put(AuthorisationViewController());

  final CIMService service = Get.find();

  @override
  Widget build(BuildContext context) {
    _controllerLogin.text = controller.user.login;
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx((){
            if(service.userMode$.value == UserMode.first){
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('welcome_admin'.tr()),
              );
            }else{
              return Container();
            }
          }),
          Obx((){
            return Text(
              '${'user_name_title'.tr()} '
                  '(${service.userMode$})',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.right,
            );
          }),
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
