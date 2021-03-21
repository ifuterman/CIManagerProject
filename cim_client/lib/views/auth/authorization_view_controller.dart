import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_client/data/data_provider.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/views/auth/authorization_view.dart';
import 'package:cim_client/views/profile/profile_page_controller.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:cim_client/cim_errors.dart';

enum AuthorisationState { idle, start, ok, error }

class AuthorizationViewController extends GetxController
    with SmartNavigationMixin<AuthorizationViewController> {
  final user = CIMUser("", "");

  final state$ = AuthorisationState.idle.obs;

  final isValidData$ = false.obs;

  DataProvider _dataProvider;
  CacheProvider _cacheProvider;

  // Future<AuthorizationViewController> init() async => this;

  @override
  GetPageBuilder get defaultGetPageBuilder => () => AuthorizationView();

  void enterData({String login, String password}) {
    isValidData$(
        (login?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false));
  }

  void clearDb() {
    _dataProvider.cleanDb().then((value) {
      Get.snackbar('Clean DB', '$value');
    });
  }

  void openProfile() {
    Get.put(
      ProfilePageController()
        ..toPage(onClose: (nav, {args}) {
          Get.back();
        }),
    );
  }

  void reconnect() {
    close(args: 'reconnect');
  }

  /// Let's suggest that we don't know about if there is admin in system.
  /// So we just try to connect.
  /// Then, if fails, system tries to make us admin.
  void authoriseUser({String login, String password}) {
    state$(AuthorisationState.start);

    _getToken(login: login, password: password).then((value) {
      state$(AuthorisationState.ok);
      if(!value){
        // FIXME(vvk): [UserRoles] -> UserRole
        final candidate = CIMUser(login, password);
        _dataProvider.createFirstUser(candidate).then((value) async {
          if (value.result == CIMErrors.ok) {
            await _getToken(login: login, password: password);
          } else {
            Get.snackbar(null, 'create first: ${value.result}');
          }
        });
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    state$(AuthorisationState.ok);
    _dataProvider = Get.find<DataProvider>();
    _cacheProvider = Get.find<CacheProvider>();
  }

  Future<bool> _getToken({String login, String password}) async {
    debugPrint('$now: AuthorizationViewController._getToken');
    final simpleCandidate = CIMUser(login, password);
    return await _dataProvider.getToken(simpleCandidate).then((value) {
      if (value.result == CIMErrors.ok) {
        final token = value.data['access_token'] as String;
        assert(null != token);
        _cacheProvider.saveToken(token);
        delayMilli(10).then((_) => close(args: true));
        return true;
      } else {
        Get.snackbar(null, 'token: ${value.result}');
        return false;
      }
    });
  }
}
