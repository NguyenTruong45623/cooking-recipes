import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';
import 'package:recipes/feature/recipeDetail/recipeDetail_controller.dart';

class RecipeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RecipeDetailController>(RecipeDetailController());
    Get.put<FavouriteController>(FavouriteController());
  }
}
