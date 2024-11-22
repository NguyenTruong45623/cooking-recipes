import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/models/message.dart';
import 'package:recipes/views/assistantMessageWidget.dart';
import 'package:recipes/views/myMessageWidget.dart';

import '../feature/chatGemini/chat_controller.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    return Obx(() => ListView.builder(
          controller: controller.scrollController,
          physics: BouncingScrollPhysics(),
          itemCount: controller.chatMessages.length,
          itemBuilder: (context, index) {
            // compare with timeSent bewfore showing the list
            final message = controller.chatMessages[index];
            return message.role.name == Role.user.name
                ? MyMessageWidget(message: message)
                : AssistantMessageWidget(message: message.message.toString());
          },
        ));
  }
}
