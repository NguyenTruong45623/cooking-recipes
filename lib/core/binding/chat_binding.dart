import 'package:get/get.dart';
import 'package:recipes/feature/chatGemini/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController());
  }
}
