import 'package:cim_client/shared/funcs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef SmartNavigationClose = Function(SmartNavigationMixin, {dynamic args});

typedef SubWidgetBuilder = Widget Function();

/// Wrapper for Get.x methods with most frequently used arguments
typedef PageRunner = Future Function(
    GetPageBuilder, {
    Bindings binding,
    Transition transition,
    Duration duration,
    });

/// Simple and effective mixin for [GetxController] and [GetxService]
/// to make navigation
mixin SmartNavigationMixin<T> on DisposableInterface {

  /// Switches global log for this
  static var logging = false;

  /// Keeps client's callback
  SmartNavigationClose _closeCallback;

  /// Flag for auto delete [T] from memory when closing
  bool _autoDelete = true;

  /// Builder for Page via Get.x
  GetPageBuilder get defaultGetPageBuilder => null;

  /// Placer in Host
  var subWidgetPlacer$ = Rx<Widget>();

  /// Sub-view for Host's [subWidgetPlacer$]
  SubWidgetBuilder get defaultSubWidgetBuilder => null;

  ///
  Future toPage({
    SmartNavigationClose onClose,
    GetPageBuilder pageBuilder,
    bool autoDelete = true,
    Transition transition,
    Duration duration,
    dynamic args,
  }) async {
    _log('Get.to(...)');
    _pageNavigate(
      Get.to,
      onClose: onClose,
      pageBuilder: pageBuilder,
      autoDelete: autoDelete,
      transition: transition,
      duration: duration,
      args: args,
    );
  }

  ///
  Future offPage({
    SmartNavigationClose onClose,
    GetPageBuilder pageBuilder,
    bool autoDelete = true,
    Transition transition,
    Duration duration,
    dynamic args,
  }) async {
    _log('Get.off(...)');
    _pageNavigate(
      Get.off,
      onClose: onClose,
      pageBuilder: pageBuilder,
      autoDelete: autoDelete,
      transition: transition,
      duration: duration,
      args: args,
    );
  }

  ///
  Future offAllPage({
    SmartNavigationClose onClose,
    GetPageBuilder pageBuilder,
    bool autoDelete = true,
    Transition transition,
    Duration duration,
    dynamic args,
  }) async {
    _log('Get.offAll(...)');
    _pageNavigate(
      Get.offAll,
      onClose: onClose,
      pageBuilder: pageBuilder,
      autoDelete: autoDelete,
      transition: transition,
      duration: duration,
      args: args,
    );
  }


  /// Deep navigation when [subWidgetBuilder]'s object
  /// places to [subWidgetPlacer$]
  void subWidgetNavigate({
    @required Rx<Widget> subWidgetPlacer$,
    @required SmartNavigationClose onClose,
    SubWidgetBuilder subWidgetBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    // It prevents from mixing without pointing to real type
    if (this is! SmartNavigationMixin<DisposableInterface>) {
      throw Exception('possibly you use wrong SmartNavigationMixin<???> '
          ' instead of SmartNavigationMixin<$runtimeType> ');
    }

    if (subWidgetPlacer$ == null) {
      throw Exception('when one do subWidgetNavigate(), '
          'subWidgetPlacer\$ must not be null');
    }
    if ((subWidgetBuilder ?? defaultSubWidgetBuilder) == null) {
      throw Exception('when one do subWidgetNavigate(), '
          'subWidgetBuilder or defaultSubWidgetBuilder '
          'must not be null');
    }
    _closeCallback = onClose;
    this._autoDelete = autoDelete;
    this.subWidgetPlacer$ = subWidgetPlacer$;
    this.subWidgetPlacer$((subWidgetBuilder ?? defaultSubWidgetBuilder).call());
  }

  /// [result] helps cooperate with [WillPopScope.onWillPop]
  ///
  Future<bool> close({bool result = true, dynamic args}) async {
    if (logging) {
      debugPrint('$now: [SNM]: close $runtimeType');
    }
    _closeCallback?.call(this, args: args);
    if (_autoDelete && result) {
      // no way to delete when result is false!
      Get.delete<T>();
    }
    return result;
  }

  ///
  Future _pageNavigate(
      PageRunner pageRunner, {
        SmartNavigationClose onClose,
        GetPageBuilder pageBuilder,
        bool autoDelete = true,
        Transition transition,
        Duration duration,
        dynamic args,
      }) async {
    // It prevents from mixing without pointing to real type
    if (this is! SmartNavigationMixin<DisposableInterface>) {
      throw Exception('possibly you use wrong SmartNavigationMixin<???> '
          ' instead of SmartNavigationMixin<$runtimeType> ');
    }

    if ((pageBuilder ?? defaultGetPageBuilder) == null) {
      throw Exception('when one do pageNavigate, pageBuilder '
          'or defaultPageBuilder must not be null');
    }
    _closeCallback = onClose;
    this._autoDelete = autoDelete;
    final builder = pageBuilder ?? defaultGetPageBuilder;
    pageRunner(
      builder,
      binding: BindingsBuilder(() => this),
      transition: transition ?? Transition.fade,
      duration: duration ?? Duration(milliseconds: 350),
    );
  }

  ///
  void _log(String method) {
    if (logging) {
      debugPrint('$now: [SNM]: open $runtimeType: Get.to(...)');
    }
  }

}

