import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipes/core/binding/home_binding.dart';

import 'core/routing/Pages.dart';
import 'core/routing/routers.dart';

void main() async {
  await Hive.initFlutter(); // Khởi tạo Hive
  await Hive.openBox('favouritesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.full,
      initialBinding: HomeBinding(),
      debugShowCheckedModeBanner: false,
      title: 'GetX Demo',
      initialRoute: Routers.splashRouter,
      getPages: Pages.getPages,
    );
  }
}
