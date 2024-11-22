import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipes/core/style/styles.dart';
import 'package:recipes/feature/recipeDetail/recipeDetail_controller.dart';
import 'package:recipes/models/Meal.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetailScreen extends GetView<RecipeDetailController> {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: YoutubePlayerBuilder(
          onEnterFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          },
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          },
          player: YoutubePlayer(
            controller: controller.playerController1,
            controlsTimeOut: Duration(seconds: 5),
            topActions: [
              Spacer(),
              Obx(() => IconButton(
                icon: Icon(
                  controller.isMuted.value
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: controller.toggleMute,
              )),
            ],
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: () {
                  final currentPosition =
                      controller.playerController1.value.position;
                  controller.playerController1
                      .seekTo(currentPosition - Duration(seconds: 10));
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10),
                onPressed: () {
                  final currentPosition =
                      controller.playerController1.value.position;
                  controller.playerController1
                      .seekTo(currentPosition + Duration(seconds: 10));
                },
              ),
              PlaybackSpeedButton(controller: controller.playerController1),
              FullScreenButton(),
            ],
          ),
          builder: (context, player) {
            bool isFullScreen = controller.playerController1.value.isFullScreen;

            return Column(
              children: [
                if (!isFullScreen) ...[
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            expandedHeight:
                            MediaQuery.of(context).size.height / 2.3 - 20,
                            elevation: 0,
                            pinned: true,
                            backgroundColor: Colors.red,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                controller.meal.strMealThumb,
                                fit: BoxFit.fill,
                              ),
                            ),
                            centerTitle: true,
                            title: Text(
                              "Meal Detail",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                fixedSize: const Size(40, 40),
                              ),
                              icon: const Icon(CupertinoIcons.chevron_back),
                            ),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  if (controller.favouriteController.myStringList
                                      .contains(controller.meal.idMeal)) {
                                    controller.favouriteController
                                        .removeFavourite(controller.meal.idMeal);
                                  } else {
                                    controller.favouriteController
                                        .addFavourite(controller.meal.idMeal);
                                  }
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  fixedSize: const Size(40, 40),
                                ),
                                icon: Obx(
                                      () => Icon(
                                    Icons.favorite,
                                    color: controller
                                        .favouriteController.myStringList
                                        .contains(controller.meal.idMeal)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                SizedBox(height: 10),
                                Text(
                                  controller.meal.strMeal,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Text(
                                    "Instructional video",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: player,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Text(
                                    'Ingredients',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                CustomIngredients(controller.meal),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Center(
                                    child: Text(
                                      "Instructions",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      controller.meal.strInstructions,
                                      style: TextStyle(color: Colors.grey.shade500),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(child: player),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget CustomIngredients(Meal meal) {
  List<Widget> ingredientWidgets = [];

  for (int i = 0; i < meal.strIngredients.length; i++) {
    if (meal.strIngredients[i] != null &&
        meal.strIngredients[i]!.isNotEmpty &&
        meal.strMeasures[i] != null &&
        meal.strMeasures[i]!.isNotEmpty) {
      ingredientWidgets.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://www.themealdb.com/images/ingredients/${meal.strIngredients[i]}-Small.png"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Expanded(
                      child: Text(
                        meal.strIngredients[i]!,
                        style: textIngredients,
                      ),
                    ),
                    Spacer(),
                    Text(
                      meal.strMeasures[i]!,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ],
                ),
                // Divider(
                //   height: 10,
                //   color: Colors.grey.shade300,
                // )
              ],
            ),
          ),
        ),
      );
    }
  }

  return Column(
    children: ingredientWidgets.isNotEmpty ? ingredientWidgets : [Container()],
  );
}
