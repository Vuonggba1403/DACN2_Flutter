import 'dart:io';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/colors.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _GeminiChatState();
}

final Gemini gemini = Gemini.instance;

List<ChatMessage> messages = [];

class _GeminiChatState extends State<ChatBot> {
  // Tạo biến user để trò chuyện
  ChatUser? currentUser;

  // Tạo biến đại diện cho Gemini bot
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "IVIVU Digibot",
    profileImage: "assets/images/chatbot.gif",
  );

  @override
  void initState() {
    super.initState();
    _promptForName(); // Hiển thị dialog để nhập tên khi khởi động
  }

  void _promptForName() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? userName = await showDialog<String>(
        context: context,
        builder: (context) {
          String nameInput = "";
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            title: const Center(child: Text("Enter Your Name")),
            content: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: ColorIcon),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Your name", border: InputBorder.none),
                  onChanged: (value) {
                    nameInput = value;
                  },
                ),
              ),
            ),
            actions: [
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).pop(nameInput); // Trả về tên đã nhập
              //   },
              //   child: const Text("OK"),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(nameInput); // Trả về tên đã nhập
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorIcon,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Opensans'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (userName != null && userName.trim().isNotEmpty) {
        setState(() {
          currentUser = ChatUser(
            id: "0",
            firstName: userName.trim(),
          );

          // Gửi tin nhắn chào mừng từ bot
          _sendWelcomeMessage(userName.trim());
        });
      } else {
        // Nếu tên không hợp lệ, yêu cầu nhập lại
        _promptForName();
      }
    });
  }

  void _sendWelcomeMessage(String userName) {
    // Tạo nội dung tin nhắn chào mừng
    String welcomeMessage = "Xin chào $userName! \n"
        "Anh/Chị đang được hỗ trợ bởi Trợ lý ảo IVUVU Digibot. \n"
        "Để được hỗ trợ tốt nhất Anh/Chị vui lòng đặt các câu hỏi ngắn gọn, dễ hiểu 👇 ";

    ChatMessage welcomeChatMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: welcomeMessage,
    );

    setState(() {
      messages = [welcomeChatMessage, ...messages];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'Chat with IVUVUDigibot',
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
            isRepeatingAnimation: true,
          ),
        ),
        backgroundColor: accentYellowColor,
      ),
      body: currentUser == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Hiển thị chờ khi chưa nhập tên
          : _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        )
      ]),
      currentUser: currentUser!,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  // Hàm gửi tin nhắn
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous${current.text}",
              ) ??
              "";
          setState(() {
            messages = [lastMessage!, ...messages];
          });
          lastMessage.text += response;
        } else {
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous${current.text}",
              ) ??
              "";

          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser!,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
