import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'chat_controller.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, String>> messages = [];
  late ChatController chatController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    chatController = ChatController(role: widget.user.role);
  }

  void sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": text});
      isLoading = true;
      inputController.clear();
    });

    _scrollToBottom();

    // typing indicator
    setState(() {
      messages.add({"sender": "bot", "text": "typing..."});
    });
    _scrollToBottom();

    final response = await chatController.sendMessage(text);

    setState(() {
      messages.removeLast();
      messages.add({"sender": "bot", "text": response});
      isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message["sender"] == "user";
    bool isTyping = message["text"] == "typing...";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blueAccent
              : isTyping
                  ? Colors.grey[300]
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isTyping
            ? const SizedBox(
                width: 60,
                height: 8,
                child: LinearProgressIndicator(),
              )
            : Text(
                message["text"]!,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue.shade600, // 🔵 BLUE BACKGROUND
        child: Center(
          child: Container(
            width: 700,
            height: 800,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,       // ⚪ WHITE BOX
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            // MAIN CHAT UI
            child: Column(
              children: [
                Text(
                  "${widget.user.role} Assistant",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // MESSAGES BOX
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          _buildMessage(messages[index]),
                    ),
                  ),
                ),

                if (isLoading) ...[
                  const SizedBox(height: 6),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 6),
                ],

                // INPUT FIELD
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          decoration: const InputDecoration(
                            hintText: "Type your message...",
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blueAccent),
                        onPressed: sendMessage,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
