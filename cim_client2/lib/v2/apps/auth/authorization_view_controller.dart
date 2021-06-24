import 'package:cim_client2/core/getx_helpers.dart';
import 'package:cim_client2/data/cim_errors.dart';
import 'package:cim_client2/v2/data/cache_provider.dart';
import 'package:cim_client2/v2/data/data_provider.dart';
import 'package:cim_client2/v2/routing/routing.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/smart_navigation.dart';
import 'package:vfx_flutter_common/utils.dart';

import 'authorization_view.dart';

enum AuthorisationState { idle, start, ok, error }

class AuthorizationViewController extends GetxController
    with SmartNavigationMixin<AuthorizationViewController> {
  final user = CIMUser("", "");

  final state$ = AuthorisationState.idle.obs;

  final isValidData$ = false.obs;

  DataProvider? _dataProvider;
  CacheProviderService? _cacheProvider;

  // Future<AuthorizationViewController> init() async => this;

  @override
  GetPageBuilder get defaultGetPageBuilder => () => AuthorizationView();

  void enterData({String? login, String? password}) {
    isValidData$(
        (login?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false));
  }

  void clearDb() {
    _dataProvider?.cleanDb().then((value) {
      AppSnackbar.std('$value',  title: 'Clean DB' );
    });
  }

  void reconnect() {
    debugPrint('$now: AuthorizationViewController.reconnect: ');
    Get.toNamed(RouteNames.connect, arguments: {});
  }

  /// Let's suggest that we don't know about if there is admin in system.
  /// So we just try to connect.
  /// Then, if fails, system tries to make us admin.
  void authoriseUser({String? login, String? password}) {
    state$(AuthorisationState.start);
    debugPrint('$now: AuthorizationViewController.authoriseUser.1');

    _getToken(login: login, password: password).then((value) {
      debugPrint('$now: AuthorizationViewController.authoriseUser. _getToken = $value');
      state$(AuthorisationState.ok);
      if(!value){
        debugPrint('$now: AuthorizationViewController.authoriseUser.2');
        // FIXME(vvk): [UserRoles] -> UserRole
        final candidate = CIMUser(login ?? '', password ?? '');
        _dataProvider?.createFirstUser(candidate).then((value) async {
          debugPrint('$now: AuthorizationViewController.authoriseUser.3: ');
          if (value.result == CIMErrors.ok) {
            // await _getToken(login: login, password: password);
            Get.snackbar('HORRAY!!!!!', 'create first: ${value.result}');
          } else {
            Get.snackbar('MANAMANA', 'create first: ${value.result}');
          }
        });
      }
      debugPrint('$now: AuthorizationViewController.authoriseUser.4');
    });
  }

  void createNewUser({String? login, String? password}) {
    debugPrint('$now: AuthorizationViewController.createNewUser.2');
    // FIXME(vvk): [UserRoles] -> UserRole
    final candidate = CIMUser(login ?? '', password ?? '');
    _dataProvider?.createFirstUser(candidate).then((value) async {
      debugPrint('$now: AuthorizationViewController.createNewUser.3: RESULT = $value');
      if (value.result == CIMErrors.ok) {
        // await _getToken(login: login, password: password);
        Get.snackbar('HORRAY!!!!!', 'create first: ${value.result}');
      } else {
        Get.snackbar('MANAMANA', 'create first: ${value.result}');
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    state$(AuthorisationState.ok);
    _dataProvider = Get.find<DataProvider>();
    _cacheProvider = Get.find<CacheProviderService>();
  }

  Future<bool> _getToken({String? login, String? password}) async {
    debugPrint('$now: AuthorizationViewController._getToken');
    final simpleCandidate = CIMUser(login ?? '', password ?? '');
    return await _dataProvider!.getToken(simpleCandidate).then((value) {
      if (value.result == CIMErrors.ok) {
        final token = value.data!['access_token'] as String;
        assert(null != token);
        _cacheProvider!.saveToken(token);
        delayMilli(10).then((_) => close(args: NavArgs.simple(true)));
        return true;
      } else {
        Get.snackbar('', 'token: ${value.result}');
        return false;
      }
    });
  }
}
