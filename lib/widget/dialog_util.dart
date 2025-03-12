import 'dart:ui';
import 'package:get/get.dart';

class DialogUtil {

  static void show() {
    if (Get.isDialogOpen == true) {
      return;
    }
    /*Get.dialog(
      LoadingWidget(),
      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      barrierDismissible: false,
    );*/
  }

  static void dismiss() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

}