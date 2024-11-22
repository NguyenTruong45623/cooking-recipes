import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:recipes/feature/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.width/2,
              child: Image(image: AssetImage("assets/images/logo.png"),fit: BoxFit.fill,)),
      ),
    );
  }
}
