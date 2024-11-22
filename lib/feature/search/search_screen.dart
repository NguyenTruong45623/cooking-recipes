import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/feature/search/search_controller.dart';

class SearchScreen extends GetView<SearchMealsController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          '${controller.search.isEmpty ? controller.categories : controller.search} Recipes',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Obx(
        () {
          // Kiểm tra trạng thái loading
          if (controller.isloading.value) {
            return Center(
                child: CircularProgressIndicator()); // Chỉ báo đang tải
          }
          if (controller.mealsList.isEmpty) {
            return Center(
                child: Text("No meals found!")); // Thông báo không có món ăn
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: controller.mealsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.toRecipeDetail(controller.mealsList[index]);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(
                                    controller.mealsList[index].strMealThumb),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: double.infinity,
                            height: 105,
                            child: customFavorite(
                                controller.mealsList[index].idMeal),
                            alignment: Alignment.topRight,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  controller.mealsList[index].strMeal,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center, // Căn giữa theo chiều ngang trong Text
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  customFavorite(String idMeal) {
    return Obx(() => IconButton(
          style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              fixedSize: Size(30, 30)),
          onPressed: () {
            if (controller.favouriteController.myStringList.contains(idMeal)) {
              controller.favouriteController.removeFavourite(idMeal);
            } else {
              controller.favouriteController.addFavourite(idMeal);
            }
          },
          icon: Icon(
            Icons.favorite,
            color: controller.favouriteController.myStringList.contains(idMeal)
                ? Colors.red
                : Colors.grey,
          ),
        ));
  }
}
