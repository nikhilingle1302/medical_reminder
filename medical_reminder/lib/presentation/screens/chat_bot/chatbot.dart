import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_reminder/presentation/screens/chat_bot/chat_bot_service.dart';


class ChatMessage {
  final String text;
  final bool isUser;
  final File? image;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.image,
  });
}
class MedicalChatScreen extends StatefulWidget {
  const MedicalChatScreen({super.key});

  @override
  State<MedicalChatScreen> createState() => _MedicalChatScreenState();
}

class _MedicalChatScreenState extends State<MedicalChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final MedicalAiService aiService =
      MedicalAiService("AIzaSyBr5ghc-9Y_nNef96JbJrccBoMgsmrXxWk");

  final List<ChatMessage> messages = [];
  File? selectedImage;
  bool loading = false;

  final suggestions = const [
    "I've been feeling dizzy lately. What should I do?",
    "Can you explain this medical image?",
    "Is this symptom serious?",
  ];

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty && selectedImage == null) return;

    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUser: true,
        image: selectedImage,
      ));
      loading = true;
    });

    _controller.clear();

    String reply;
    if (selectedImage != null) {
      reply = await aiService.sendImageWithText(
        text: text.isEmpty ? "Explain this medical image" : text,
        image: selectedImage!,
      );
    } else {
      reply = await aiService.sendText(text);
    }

    setState(() {
      messages.add(ChatMessage(text: reply, isUser: false));
      selectedImage = null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical AI Assistant"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Suggestions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((s) {
                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: ActionChip(
                    label: Text(s),
                    onPressed: () => _controller.text = s,
                  ),
                );
              }).toList(),
            ),
          ),

          // Chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(msg.image!, height: 150),
                          ),
                        if (msg.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(msg.text),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          // Input Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Describe symptoms or upload image",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
