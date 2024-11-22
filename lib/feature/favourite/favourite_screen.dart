import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';

class FavouriteScreen extends GetView<FavouriteController> {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Favourite",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.removeAllFavourite();
              },
              icon: Icon(Icons.delete_sweep,color: Colors.white,size: 25,))
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (controller.isLoading.value)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (controller.favouriteList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No favourite meals yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              else
                ...controller.favouriteList.map<Widget>((meal) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(meal.strMeal),
                      leading: Image.network(meal.strMealThumb,
                          width: 50, height: 50, fit: BoxFit.cover),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          controller.removeFavourite(
                              meal.idMeal); // Xóa món ăn khỏi danh sách
                        },
                      ),
                      onTap: () {
                        controller.toRecipeDatail(meal);
                      },
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }
}
