import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/components/button.dart';
import 'package:incident_tracker/components/inputs.dart';
import 'package:incident_tracker/controllers/user_controller.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/helper_functions.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  loginHandler() async {
    if (_formKey.currentState!.validate()) {
      final success =
          await Provider.of<AuthController>(context, listen: false).login(
        emailController.text,
        passwordController.text,
      );

      if (success && mounted) {
        context.pushReplacement(AppRoutes.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool isLoading = Provider.of<AuthController>(context).isLoading;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              // logo image in assets
              SizedBox(
                width: 250,
                height: height * 0.15,
                child: Image.asset(
                  'assets/images/logo.png',
                  color: primaryColor,
                ),
              ),

              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "Log Into Your Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    inputText(
                        controller: emailController,
                        hint: "Enter your email",
                        label: "Email",
                        validator: (value) {
                          // min 6 char
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!validateEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                    passwordInput(
                      controller: passwordController,
                      hint: "Password",
                      label: "Password",
                      visibility: isPasswordVisible,
                      validator: (value) {
                        // min 6 char
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      toggleVisibility: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      required:
                          false, // for ui purposes, will be required in validation
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: false,
                        onChanged: (value) {},
                      ),
                      const Text(
                        "Keep me signed in",
                      ),
                    ],
                  ),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Button(
                "Sign In",
                () async {
                  await loginHandler();
                },
                context,
                loading: isLoading,
                radius: 10,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(7))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Or Continue With",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(7))),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/google.png",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Google")
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/apple.png",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Apple")
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.05,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
