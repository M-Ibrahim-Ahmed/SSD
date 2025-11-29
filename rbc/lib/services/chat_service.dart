import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String serverUrl;

  ChatService({required this.serverUrl});

  Future<String> getResponse(String role, String message) async {
    final Uri url = Uri.parse("$serverUrl/chat");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "role": role,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🔥 Fixed key name
        return data["response"] ?? "No reply from server.";
      }

      return "Server error: ${response.statusCode}";
    } catch (e) {
      return "Error contacting server: $e";
    }
  }
}
