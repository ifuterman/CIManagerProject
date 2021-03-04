import 'dart:ui';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/pref_service.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/views/auth/authorization_view_controller.dart';
import 'package:cim_client/views/shared/ui_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide Trans;

class AuthorizationView extends GetView<AuthorizationViewController> {
  final pref = Get.find<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DebuggableWidget(
          mainWidget: _MainWidget(),
          debugItems: {
            'clean DB': () {
              final provider = Get.find<DataProvider>();
              provider.cleanDb().then((value) {
                Get.snackbar('Clean DB', '$value');
              });
            },
            'change theme': pref.switchDarkMode,
          },
          top: 5,
        ),
      ),
    );
  }
}

class _MainWidget extends GetView<AuthorizationViewController> {
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();

  // final controller = Get.put(AuthorisationViewController());

  final CIMService service = Get.find();

  @override
  Widget build(BuildContext context) {
    _controllerLogin.text = controller.user.login;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (service.userMode$.value == UserMode.first) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('welcome_admin'.tr()),
                  );
                } else {
                  return Container();
                }
              }),
              Obx(() {
                return Text(
                  '${'user_name_title'.tr()} '
                  '(${service.userMode$})',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.right,
                );
              }),
              Container(
                constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.headline6.fontSize * 1.2,
                    width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
                child: TextField(
                  controller: _controllerLogin,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => controller.enterData(
                    login: _controllerLogin.text,
                    password: _controllerPassword.text,
                  ),
                ),
              ),
              Text(
                'user_password_title'.tr(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.right,
              ),
              Container(
                constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.headline6.fontSize * 1.2,
                    width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
                child: TextField(
                  controller: _controllerPassword,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => controller.enterData(
                    login: _controllerLogin.text,
                    password: _controllerPassword.text,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Obx(
                () => ElevatedButton(
                  child: Text("user_authorize_title".tr()),
                  onPressed: controller.isValidData$.value
                      ? () {
                          controller.authoriseUser(
                            login: _controllerPassword.text,
                            password: _controllerLogin.text,
                          );
                        }
                      : null,
//              onPressed: () => viewModel.authorizeUser(),
                ),
              ),
              TextButton(
                child: Text(
                  "connection_options".tr(),
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  service.currentView.value = CIMViews.connectionView;
                },
              ),
              if (kDebugMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        "Clean DB",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: controller.clearDb,
                    ),
                    TextButton(
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: controller.openProfile,
                    ),
                  ],
                )
            ],
          ),
        ),
        Obx(() {
          return controller.state$.value == AuthorisationState.start
              ? _ProgressIndicator()
              : Container();
        }),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
