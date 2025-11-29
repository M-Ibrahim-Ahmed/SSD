import '../services/chat_service.dart';

class ChatController {
  final String role;
  final ChatService chatService = ChatService(serverUrl: "http://192.168.18.40:5000");

  ChatController({required this.role});

  Future<String> sendMessage(String input) async {
    return await chatService.getResponse(role, input);
  }
}
