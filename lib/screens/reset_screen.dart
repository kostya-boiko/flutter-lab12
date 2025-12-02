import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lab12/screens/home_screen.dart';
import '/utils/email_validator.dart';
import '../widgets/standard_input.dart';
import 'sign_in_screen.dart';
import '../widgets/standard_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  bool isEmailSend = false;
  bool isLoading = false;
  String? globalError;
  String? emailError;

  final dio = Dio();

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    setState(() {
      globalError = null;
      emailError = null;
      isLoading = true;
    });

    if (!validateEmail(email)) {
      setState(() {
        emailError = "Please enter a valid email";
      });
      return;
    }

    try {
      final response = await dio.post(
        'https://lab12.requestcatcher.com/',
        data: {"email": emailController.text.trim()},
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

    setState(() {
      isLoading = false;
      isEmailSend = true;
      emailError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: isEmailSend
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 60,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Email has been sent!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Follow the instructions in the email to reset your password.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: StandardButton(
                            textInfo: 'Sign in',
                            isAccent: true,
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            isLoading: isLoading,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/1024px-Google-flutter-logo.svg.png',
                      width: 150,
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
                      labelText: 'Email',
                      controller: emailController,
                      errorText: emailError,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: StandardButton(
                            textInfo: 'Reset password',
                            isAccent: true,
                            onClick: resetPassword,
                            isLoading: isLoading,
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
