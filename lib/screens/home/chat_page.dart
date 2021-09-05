import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/chat_controller.dart';
import 'package:flutter_application_1/shared/fun_time.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatelessWidget {
  final String requestId;
  final String fromId;
  final String toId;
  final String email;

  ChatPage({this.requestId, this.fromId, this.toId, this.email});
  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    chatController.buildStream(requestId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chat with $email'),
      // ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back()),
                  Expanded(
                    child: (email == null)
                        ? Text(
                            'Chat',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        : Text(
                            'Chat with $email',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => (chatController.chats.isEmpty)
                    ? SizedBox()
                    : Column(
                        children: [
                          ...chatController.chats.map((item) {
                            return Align(
                              alignment: (fromId == item.from)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(
                                        (fromId == item.from) ? 10 : 0),
                                    bottomRight: Radius.circular(
                                        (fromId == item.from) ? 0 : 10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: (fromId == item.from)
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    (item.image != 'no image')
                                        ? Image.network(item.image,
                                            width: 240, fit: BoxFit.cover)
                                        : SizedBox(),
                                    SizedBox(height: 4),
                                    Text(
                                      item.chat,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 6),
                                    Text(readTimestamp(item.timeStamp)),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: chatController.textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Type here...",
                      ),
                    ),
                  ),
                  buttonChat(
                      icon: Icons.camera_alt_rounded,
                      onTap: () {
                        chatController.getImage(ImageSource.gallery);
                        Get.to(() => ChatImagePage(
                              requestId: requestId,
                              fromId: fromId,
                              toId: toId,
                            ));
                      }),
                  buttonChat(
                      icon: Icons.send,
                      onTap: () {
                        chatController.addChat(requestId, fromId, toId);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatImagePage extends StatelessWidget {
  final String requestId;
  final String fromId;
  final String toId;

  ChatImagePage({this.requestId, this.fromId, this.toId});
  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => (chatController.selectedImagePath.value == '')
            ? SizedBox()
            : Column(
                children: [
                  Expanded(
                    child: Image.file(
                      File(chatController.selectedImagePath.value),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: chatController.textController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Add caption",
                              ),
                            ),
                          ),
                          buttonChat(
                              icon: Icons.send,
                              onTap: () async {
                                var image = await chatController.postImage();
                                chatController.addChat(requestId, fromId, toId,
                                    image: image);
                                Get.back();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget buttonChat({IconData icon, Function() onTap}) {
  return Container(
    margin: EdgeInsets.only(left: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: Colors.lightBlue[600],
      ),
      disabledColor: Colors.blueGrey,
    ),
  );
}
