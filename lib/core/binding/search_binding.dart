import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';
import 'package:recipes/feature/search/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SearchMealsController>(SearchMealsController());
    Get.put<FavouriteController>(FavouriteController());
  }
}
