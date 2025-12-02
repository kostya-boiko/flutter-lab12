import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lab12/screens/home_screen.dart';
import '/utils/email_validator.dart';
import '/utils/password_validator.dart';

import '../widgets/standard_button.dart';
import '../widgets/standard_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? nameError;
  String? confirmError;
  String? globalError;

  final dio = Dio();

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final confirm = confirmController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
      nameError = null;
      confirmError = null;
      globalError = null;
      isLoading = true;
    });

    bool hasError = false;

    if (!validateEmail(email)) {
      emailError = "Invalid email format";
      hasError = true;
    }

    if (!validatePassword(password)) {
      passwordError = "Minimum 7 characters";
      hasError = true;
    }

    if (name.length < 2) {
      nameError = "Minimum 2 characters";
      hasError = true;
    }

    if (confirm != password) {
      confirmError = "Passwords do not match";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    try {
      final response = await dio.post(
        'https://lab12.requestcatcher.com/',
        data: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print(response.statusCode);
        throw Exception('Status code ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        globalError = e.toString();
      });
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/1024px-Google-flutter-logo.svg.png',
              width: 300,
            ),
            const SizedBox(height: 30),

            if (globalError != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        globalError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            StandardInput(
              isObscureText: false,
              labelText: 'Name',
              controller: nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 10),

            StandardInput(
              isObscureText: false,
              labelText: 'Email',
              controller: emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 10),

            StandardInput(
              isObscureText: true,
              labelText: 'Password',
              controller: passwordController,
              errorText: passwordError,
            ),
            const SizedBox(height: 10),

            StandardInput(
              isObscureText: true,
              labelText: 'Confirm password',
              controller: confirmController,
              errorText: confirmError,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: StandardButton(
                    textInfo: 'Sign Up',
                    isAccent: true,
                    onClick: signUp,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
