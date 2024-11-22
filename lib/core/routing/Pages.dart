import 'package:get/get.dart';
import 'package:recipes/core/binding/chat_binding.dart';
import 'package:recipes/core/binding/faouritebinding.dart';
import 'package:recipes/core/binding/home_binding.dart';
import 'package:recipes/core/binding/recipeDetail_binding.dart';
import 'package:recipes/core/binding/recipes_binding.dart';
import 'package:recipes/core/binding/search_binding.dart';
import 'package:recipes/core/binding/splash_binding.dart';
import 'package:recipes/core/routing/routers.dart';
import 'package:recipes/feature/favourite/favourite_screen.dart';
import 'package:recipes/feature/home/home_screen.dart';
import 'package:recipes/feature/recipeDetail/recipeDetail_screen.dart';
import 'package:recipes/feature/search/search_screen.dart';
import 'package:recipes/feature/splash/splash_page.dart';

import '../../feature/chatGemini/chat_screen.dart';
import '../../feature/recipes/recipes_screen.dart';

class Pages {
  static List<GetPage> getPages = [
    GetPage(
        name: Routers.splashRouter,
        page: () => const SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: Routers.homeRouter,
        page: () => const HomeScreen(),
        bindings: [
          HomeBinding(),
          RecipesBinding(),
          FavouriteBinding(),
          ChatBinding()
        ]),
    GetPage(
        name: Routers.recipesRouter,
        page: () => const RecipesScreen(),
        bindings: [RecipesBinding()]),
    GetPage(
        name: Routers.recipesDetailRouter,
        page: () => RecipeDetailScreen(),
        binding: RecipeDetailBinding()),
    GetPage(
        name: Routers.favouriteRouter,
        page: () => FavouriteScreen(),
        binding: FavouriteBinding()),
    GetPage(
        name: Routers.searchRouter,
        page: () => SearchScreen(),
        binding: SearchBinding()),
    GetPage(
        name: Routers.chatRouter,
        page: () => ChatScreen(),
        binding: ChatBinding()),
  ];
}
