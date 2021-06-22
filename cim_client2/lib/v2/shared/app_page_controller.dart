import 'package:cim_client2/v2/apps/main/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

/// For view paging, aka [PageView].
/// Helps to Control when page is showing and hiding.
/// See [MainViewController] how to manipulate with.
abstract class AppPageController extends GetxControllerProxy {
  void onPageHide(AppPageController sender) {
    AppSnackbar.std('$runtimeType', title: 'OnPageHide');
  }

  void onPageShow(AppPageController sender) {
    AppSnackbar.std('$runtimeType', title: 'OnPageShow');
  }
}
