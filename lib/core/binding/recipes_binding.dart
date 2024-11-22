import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';
import 'package:recipes/feature/recipes/recipes_controller.dart';

class RecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavouriteController>(FavouriteController());
    Get.put<RecipesController>(RecipesController());
  }
}
