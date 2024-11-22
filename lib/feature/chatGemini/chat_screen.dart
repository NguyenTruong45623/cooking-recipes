import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/feature/chatGemini/chat_controller.dart';

import '../../views/bottomChatField.dart';
import '../../views/chatMessages.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Chat with Gemini',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () => controller.deleteChat(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          searchFocusNode.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Theme.of(context).textTheme.titleLarge!.color!,
                  ),
                ),
                child: BottomChatField(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
