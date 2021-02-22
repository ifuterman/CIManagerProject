import 'package:cim_client/shared/funcs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef SmartNavigationClose = Function(SmartNavigationMixin, {dynamic args});

typedef PageBuilder<T> = Future<T> Function();

typedef SubWidgetBuilder = Widget Function();

/// Simple and effective mixin for [GetxController] and [GetxService]
/// to make navigation
mixin SmartNavigationMixin<T> {
  SmartNavigationClose closeCallback;
  bool autoDelete;
  var subWidgetPlacer = Rx<Widget>();

  PageBuilder get defaultPageBuilder => null;

  SubWidgetBuilder get defaultSubWidgetBuilder => null;

  Future<dynamic> to(GetPageBuilder builder) => Get.to(builder, binding: BindingsBuilder(()=>this));
  Future<dynamic> off(GetPageBuilder builder) => Get.off(builder, binding: BindingsBuilder(()=>this));
  // Future<dynamic> off(dynamic page) => Get.off(page, binding: BindingsBuilder(()=>this));
  // Future<dynamic> offAll(dynamic page) => Get.offAll(page, binding: BindingsBuilder(()=>this));

  void subWidgetNavigate({
    @required Rx<Widget> subWidgetPlacer,
    @required SmartNavigationClose onClose,
    SubWidgetBuilder subWidgetBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    if (subWidgetPlacer == null) {
      throw Exception(
          'when one do subWidgetNavigate(), '
              'subWidgetPlacer must not be null');
    }
    if ((subWidgetBuilder ?? defaultSubWidgetBuilder) == null) {
      throw Exception('when one do subWidgetNavigate(), '
          'subWidgetBuilder or defaultSubWidgetBuilder '
          'must not be null');
    }
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    this.subWidgetPlacer = subWidgetPlacer;
    this.subWidgetPlacer((subWidgetBuilder ?? defaultSubWidgetBuilder).call());
  }

  ///
  void pageNavigate({
    SmartNavigationClose onClose,
    PageBuilder pageBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    if ((pageBuilder ?? defaultPageBuilder) == null) {
      throw Exception('when one do pageNavigate, pageBuilder '
          'or defaultPageBuilder must not be null');
    }
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    (pageBuilder ?? defaultPageBuilder)?.call();
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
