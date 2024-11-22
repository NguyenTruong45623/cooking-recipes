import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = RxInt(1);

  void changeIndex(int index) {
    this.index.value = index;
  }
}
