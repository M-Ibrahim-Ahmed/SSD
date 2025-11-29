import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = "Doctor";
  bool loading = false;

  Future<void> signup() async {
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:5000/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": idController.text.trim(),
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "role": role,
        }),
      );

      setState(() => loading = false);

      if (res.statusCode == 200) {
        final newUser = User(
          id: idController.text.trim(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          role: role,
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Signup successful!")));

        Navigator.pop(context, newUser);
      } else {
        final data = jsonDecode(res.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['error'] ?? "Signup failed")));
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
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
                  const Text("Create Account",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0))),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: "User ID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email (for MFA)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: role,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(value: "Doctor", child: Text("Doctor")),
                        DropdownMenuItem(value: "Nurse", child: Text("Nurse")),
                        DropdownMenuItem(value: "Patient", child: Text("Patient")),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => role = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: signup,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text("Create Account",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
