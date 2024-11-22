import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/feature/recipes/recipes_controller.dart';

class RecipesScreen extends GetView<RecipesController> {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String imagePath = "assets/images/banner.jpg";
    final FocusNode searchFocusNode = FocusNode(); // Khởi tạo FocusNode

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            searchFocusNode.unfocus();
          },
          child: Obx(
            () => Container(
              decoration: BoxDecoration(color: Colors.white),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    title: customSearch(searchFocusNode),
                    // Truyền FocusNode vào hàm customSearch
                    backgroundColor: Colors.red,
                    expandedHeight: 200.0,
                    elevation: 0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
                    sliver: SliverToBoxAdapter(
                      child: const Text("List Categories",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 60, // Đặt chiều cao cố định cho ListView cuộn ngang
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.categoriesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              controller.categoriesToSearch(controller.categoriesList[index]);
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    controller.categoriesList[index],
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
                    sliver: SliverToBoxAdapter(
                      child: const Text("Cooking Recipes",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    ),
                  ),
                  if (controller.isLoading.value)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final meal = controller.mealList[index];
                            return GestureDetector(
                              onTap: () {
                                controller.toRecipeDetail(meal);
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(meal.strMealThumb),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 115,
                                      child: customFavorite(meal.idMeal),
                                      alignment: Alignment.topRight,
                                    ),
                                    const SizedBox(height: 2),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            meal.strMeal,
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
                            );
                          },
                          childCount: controller.mealList.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
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
            controller.printlist();
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

  customSearch(FocusNode searchFocusNode) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: controller.searchController,
        focusNode: searchFocusNode,
        cursorWidth: 1.0,
        onFieldSubmitted: (value) {
          controller.toSearch(value);
          controller.searchController.clear();
        },
        style: const TextStyle(color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 0.5,
            ),
          ),
          suffixIcon: const Icon(Icons.search, size: 25),
          hintText: "Nhập tên món ăn...",
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}
