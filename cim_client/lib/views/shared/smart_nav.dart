import 'package:cim_client/shared/funcs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef SmartNavigationClose = Function(SmartNavigationMixin, {dynamic args});

typedef PageBuilder<T> = Future<T> Function();

typedef WidgetBuilder = Widget Function();

mixin SmartNavigationMixin<T> {
  SmartNavigationClose closeCallback;
  bool autoDelete;
  var widgetPlacer = Rx<Widget>();

  PageBuilder get defaultPageBuilder => null;

  WidgetBuilder get defaultWidgetBuilder => null;

  void subNavigate({
    @required Rx<Widget> widgetPlacer,
    @required SmartNavigationClose onClose,
    WidgetBuilder widgetBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    if(widgetPlacer == null){
      throw Exception('widgetPlacer == null');
    }
    if((widgetBuilder ?? defaultWidgetBuilder) == null){
      throw Exception('widgetBuilder ?? defaultWidgetBuilder == null');
    }
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    this.widgetPlacer = widgetPlacer;
    this.widgetPlacer((widgetBuilder ?? defaultWidgetBuilder).call());
  }

  ///
  void pageNavigate({
    SmartNavigationClose onClose,
    PageBuilder pageBuilder,
    bool autoDelete = true,
    dynamic args,
  }) {
    if((pageBuilder ?? defaultPageBuilder) == null){
      throw Exception('pageBuilder ?? defaultPageBuilder == null');
    }
    closeCallback = onClose;
    this.autoDelete = autoDelete;
    // debugPrint('$now: SmartNavigationMixin2.pageNavigate: '
    //     'pageBuilder = $pageBuilder, '
    //     'defaultPageBuilder = $defaultPageBuilder');
    (pageBuilder ?? defaultPageBuilder)?.call();
  }

  ///
  void close({dynamic args}) {
    closeCallback?.call(this, args: args);
    if(autoDelete){
      debugPrint('$now: SmartNavigationController.close.2: $runtimeType');
      Get.delete<T>();
    }
  }
}

