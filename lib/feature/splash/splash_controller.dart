
import 'package:get/get.dart';

import '../../core/routing/routers.dart';


class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    goToHome();
  }
  void goToHome() {
    Future.delayed(const Duration(seconds: 1), () async {
      await Get.offAllNamed(Routers.homeRouter);
    });
  }
}
