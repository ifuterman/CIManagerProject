import 'dart:ui';
import 'package:cim_client2/core/services/cim_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'authorization_view_controller.dart';

class AuthorizationView extends GetViewSim<AuthorizationViewController> {
  static const pageTitle = '/Auth';
  static GetPage page = GetPage(
    name: pageTitle,
    page: () => AuthorizationView(),
    binding: BindingsBuilder.put(() => AuthorizationViewController()),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _MainWidget(),
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
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                    child: TextField(
                      controller: _controllerPassword,
                      textAlignVertical: TextAlignVertical.top,
                      obscureText: !kDebugMode,
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
                              controller.createNewUser(
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
                    onPressed: controller.reconnect,
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
                      ],
                    )
                ],
              ),
            ),
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
