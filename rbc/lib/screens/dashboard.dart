import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../chat/chat_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text("${user.role} Dashboard"),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${user.name}!",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              UserInfoCard(label: "Full Name", value: user.name),
              UserInfoCard(label: "User ID", value: user.id),
              UserInfoCard(label: "Email", value: user.email),
              UserInfoCard(label: "Role", value: user.role),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: user),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 24),
                  label: const Text(
                    "Open Chatbot",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // semi-transparent to show gradient
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
