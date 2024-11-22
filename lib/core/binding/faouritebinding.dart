import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';

class FavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavouriteController>(FavouriteController());
  }
}
