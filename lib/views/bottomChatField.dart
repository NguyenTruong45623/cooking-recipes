import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/previewImageWidget.dart';
import 'package:recipes/views/showMyAnimateDialog.dart';

import '../feature/chatGemini/chat_controller.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();
    final ChatController controller = Get.find<ChatController>();

    return Obx(() => Column(
          children: [
            if (controller.hasImage.value) const PreviewImagesWidget(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    print("object: ${controller.hasImage.value}");
                    if (controller.hasImage.value) {
                      showMyAnimatedDialog(
                        context: context,
                        title: 'Delete Images',
                        content: 'Are you sure you want to delete the images?',
                        actionText: 'Delete',
                        onActionPressed: (value) {
                          if (value) {
                            // Xóa tất cả ảnh trong danh sách
                            controller.setImagesFileList(listValue: []);
                          }
                        },
                      );
                    } else {
                      // Mở modal bottom sheet để người dùng chọn hành động
                      _showAttachmentOptions(context, controller);
                    }
                  },
                  icon: Icon(
                    controller.hasImage.value
                        ? Icons.delete_forever
                        : Icons.image,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: controller.newMessageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: controller.isLoading.value
                        ? null
                        : (value) {
                            if (value.isNotEmpty) {
                              controller.sentChatMessage(
                                message: value,
                                isTextOnly: !controller
                                    .hasImage.value, // Nếu có ảnh, gửi với ảnh
                              );
                            }
                          },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter a prompt...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () {
                          if (controller.newMessageController.text.isNotEmpty) {
                            controller.sentChatMessage(
                              message: controller.newMessageController.text,
                              isTextOnly: !controller
                                  .hasImage.value, // Nếu có ảnh, gửi với ảnh
                            );
                            searchFocusNode.unfocus();
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _showAttachmentOptions(BuildContext context, ChatController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Đính kèm ảnh'),
                onTap: () {
                  controller.pickImage(); // Gọi phương thức chọn ảnh
                  Navigator.pop(context); // Đóng modal sau khi chọn ảnh
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  controller.getImageFromCamera(); // Gọi phương thức chụp ảnh
                  Navigator.pop(context); // Đóng modal sau khi chụp ảnh
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text('Đính kèm tệp'),
                onTap: () {
                  // Xử lý khi chọn đính kèm tệp khác
                  Navigator.pop(context); // Đóng modal
                },
              ),
              ListTile(
                title: const Center(
                  child: Text(
                    'Hủy',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Đóng modal
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
