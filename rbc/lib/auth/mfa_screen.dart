import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_model.dart';
import '../screens/dashboard.dart';

class MFAScreen extends StatefulWidget {
  final User user;
  const MFAScreen({super.key, required this.user});

  @override
  State<MFAScreen> createState() => _MFAScreenState();
}

class _MFAScreenState extends State<MFAScreen> {
  final TextEditingController codeController = TextEditingController();
  bool loading = false;

  Future<void> verifyMFA() async {
    if (codeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter MFA code")));
      return;
    }

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:5000/verify-mfa"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.user.email,
          "code": codeController.text.trim()
        }),
      );

      setState(() => loading = false);

      if (res.statusCode == 200 && jsonDecode(res.body)["verified"] == true) {
        Navigator.pushReplacementNamed(
          context,
          Dashboard.routeName,
          arguments: widget.user,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid MFA code!")));
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Blue gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter the 6-digit code sent to your email"),
                const SizedBox(height: 20),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "MFA Code",
                  ),
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: verifyMFA,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Verify",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
