import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/message.dart';
import 'package:recipes/utils/api/api_service.dart';

class ChatController extends GetxController {
  final scrollController = ScrollController();
  final newMessageController = TextEditingController();
  RxBool isLoading = false.obs;
  var chatMessages = <Message>[].obs;
  var imagesFileList = <XFile>[].obs;
  RxBool hasImage = false.obs;
  final ImagePicker picker = ImagePicker();
  List<Content> history = [];

  // Phương thức lấy API key

  // Khởi tạo mô hình GenerativeModel trong phương thức thay vì trực tiếp
  var model = Rxn<GenerativeModel>();

  @override
  void onInit() {
    super.onInit();
    // Đồng bộ ngay tại thời điểm khởi tạo
    hasImage.value = imagesFileList.isNotEmpty;
    ever(imagesFileList, (_) => hasImage.value = imagesFileList.isNotEmpty);
  }

  List<String> getImagesUrls({required bool isTextOnly}) => // Hàm rút gọn
      isTextOnly ? [] : imagesFileList.map((image) => image.path).toList();

  Future<String> getApiKey() async {
    return ApiService.apiKey.toString();
  }

  Future<void> pickImage() async {
    try {
      final pickedImages = await picker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      if (pickedImages.isNotEmpty) {
        setImagesFileList(listValue: pickedImages);
      } else {
        log('No images selected.');
      }
    } catch (e) {
      log('Error picking images: $e');
    }
  }

  Future<void> getImageFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagesFileList.add(image);
    }
  }

  void setImagesFileList({required List<XFile> listValue}) {
    imagesFileList.assignAll(listValue);
  }

  Future<void> _initializeModel() async {
    final apiKey = await getApiKey();
    model.value = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );
  }

  // Phương thức gửi tin nhắn
  Future<void> sentChatMessage(
      {required String message, required bool isTextOnly}) async {
    try {
      if (model.value == null) {
        // Khởi tạo chỉ khi cần
        await _initializeModel();
      }
      await sendMessageAndWaitForResponse(
          message: message, isTextOnly: isTextOnly);
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required bool isTextOnly,
  }) async {
    final userMessage = Message(
      messageId: chatMessages.length.toString(),
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: getImagesUrls(isTextOnly: isTextOnly),
    );

    chatMessages.add(userMessage);
    final content = await getContent(message: message, isTextOnly: isTextOnly);
    history.add(content);

    var chatSession = model.value!.startChat(
      history: history.isEmpty ? null : history,
    );

    // xóa text và ảnh ở bottomchatfeild
    newMessageController.clear();
    setImagesFileList(listValue: []);

    final assistantMessage = userMessage.copyWith(
      messageId: (chatMessages.length + 1).toString(),
      role: Role.assistant,
      message: StringBuffer(),
    );

    chatMessages.add(assistantMessage);

    scrollToBottom();

    var response = await chatSession.sendMessage(content);

    assistantMessage.message.write(response.text);

    history.add(Content.model([TextPart(response.toString())]));

    int index = chatMessages
        .indexWhere((msg) => msg.messageId == assistantMessage.messageId);
    if (index != -1) {
      // Cập nhật tin nhắn trong danh sách nếu tìm thấy
      chatMessages[index] = assistantMessage;
    }
    // Xử lý phản hồi từ chat
    // print('Response: ${response.text}');
    scrollToBottom();
  }

  Future<Content> getContent(
      {required String message, required bool isTextOnly}) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = imagesFileList
          .map((imageFile) => imageFile.readAsBytes())
          .toList(growable: false);

      final imageBytes = await Future.wait(imageFutures);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  void deleteChat() {
    chatMessages.clear();
    history.clear();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
