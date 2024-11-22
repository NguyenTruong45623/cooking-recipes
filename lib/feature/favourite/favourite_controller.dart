import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:recipes/core/routing/routers.dart';
import 'package:recipes/models/Meal.dart';

class FavouriteController extends GetxController {
  RxList<String> myStringList = <String>[].obs;
  RxBool isLoading = false.obs;
  var favouriteList = <Meal>[].obs;

  void loadFavourites() {
    var box = Hive.box('favouritesBox');
    myStringList.value =
        List<String>.from(box.get('favouriteList', defaultValue: []));
    fetchFavouriteMeals();
  }

  Future<void> addFavourite(String itemId) async {
    if (!myStringList.contains(itemId)) {
      myStringList.add(itemId);
      saveFavourites();
      await fetchAndSaveMealDetails(itemId);
    }
  }

  void removeFavourite(String itemId) {
    myStringList.remove(itemId);
    saveFavourites();
    favouriteList.removeWhere((meal) => meal.idMeal == itemId);
  }

  void removeAllFavourite() {
    myStringList.clear();
    saveFavourites();
    favouriteList.clear();
  }

  void saveFavourites() {
    var box = Hive.box('favouritesBox');
    box.put('favouriteList', myStringList);
  }

  Future<void> fetchAndSaveMealDetails(String itemId) async {
    final response = await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['meals'] != null && data['meals'].isNotEmpty) {
        Meal meal = Meal.fromJson(data['meals'][0]);
        favouriteList.add(meal);
      }
    }
  }

  Future<void> fetchFavouriteMeals() async {
    isLoading(true);
    List<Meal> fetchedMeals = [];
    for (var id in myStringList) {
      final response = await http.get(Uri.parse(''));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          fetchedMeals.add(Meal.fromJson(data['meals'][0]));
        }
      }
    }
    favouriteList.assignAll(fetchedMeals);
    isLoading(false);
  }

  void toRecipeDatail(Meal meal) {
    Get.toNamed(Routers.recipesDetailRouter, arguments: {"GetMeal": meal});
  }

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }
}
