import 'package:get/get.dart';
import 'package:recipes/feature/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }

}