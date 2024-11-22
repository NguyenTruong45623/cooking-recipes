import 'package:get/get.dart';
import 'package:recipes/feature/favourite/favourite_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/Meal.dart';

class RecipeDetailController extends GetxController {
  final Meal meal = Get.arguments?["GetMeal"] as Meal;
  late YoutubePlayerController playerController1;
  FavouriteController favouriteController = Get.find<FavouriteController>();

  var isMuted = false.obs;

  @override
  void onInit() {
    final videoId = YoutubePlayer.convertUrlToId(meal.strYoutube!);
    playerController1 = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.onInit();
  }

  void toggleMute() {
    if (isMuted.value) {
      playerController1.unMute();
    } else {
      playerController1.mute();
    }
    isMuted.value = !isMuted.value;
  }

  @override
  void onClose() {
    playerController1.dispose();
    super.onClose();
  }
}
