import 'package:cim_client/shared/funcs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef SmartNavigationClose = Function(SmartNavigationMixin, {dynamic args});

typedef PageBuilder<T> = Future<T> Function();

typedef SubWidgetBuilder = Widget Function();

/// Simple and effective mixin for [GetxController] and [GetxService]
/// to make navigation
mixin SmartNavigationMixin<T> on DisposableInterface {
  SmartNavigationClose closeCallback;
  bool autoDelete;
  var subWidgetPlacer$ = Rx<Widget>();

  PageBuilder get defaultPageBuilder => null;

  SubWidgetBuilder get defaultSubWidgetBuilder => null;

  /// Dispatches to the same Get method with binding to [this]
  Future<dynamic> to(
      GetPageBuilder builder, {
        Transition transition,
        Duration duration,
      }) =>
      Get.to(
        builder,
        binding: BindingsBuilder(() => this),
        transition: transition ?? Transition.fade,
        duration: duration ?? Duration(milliseconds: 350),
      );

  /// Dispatches to the same Get method with binding to [this]
  Future<dynamic> off(
      GetPageBuilder builder, {
        Transition transition,
        Duration duration,
      }) =>
      Get.off(
        builder,
        binding: BindingsBuilder(() => this),
        transition: transition ?? Transition.fade,
        duration: duration ?? Duration(milliseconds: 350),
      );

  /// Dispatches to the same Get method with binding to [this]
  Future<dynamic> offAll(
      GetPageBuilder builder, {
        Transition transition,
        Duration duration,
      }) =>
      Get.offAll(
        builder,
        binding: BindingsBuilder(() => this),
        transition: transition ?? Transition.fade,
        duration: duration ?? Duration(milliseconds: 350),
      );

  /// Plain navigation to some page
  void pageNavigate({
    SmartNavigationClose onClose,
    PageBuilder pageBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    // It prevents from mixing without pointing to real type
    if (this is! SmartNavigationMixin<DisposableInterface>) {
      throw Exception('possibly you use wrong SmartNavigationMixin<???> '
          ' instead of SmartNavigationMixin<$runtimeType> ');
    }

    if ((pageBuilder ?? defaultPageBuilder) == null) {
      throw Exception('when one do pageNavigate, pageBuilder '
          'or defaultPageBuilder must not be null');
    }
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    (pageBuilder ?? defaultPageBuilder)?.call();
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
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    this.subWidgetPlacer$ = subWidgetPlacer$;
    this.subWidgetPlacer$((subWidgetBuilder ?? defaultSubWidgetBuilder).call());
  }

  ///
  Future<bool> close({bool result = true, dynamic args}) async {
    closeCallback?.call(this, args: args);
    if (autoDelete && result) {
      // no way to delete when result is false!
      Get.delete<T>();
    }
    return result;
  }
}


