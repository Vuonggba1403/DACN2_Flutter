import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../utils/colors.dart';
import '../../utils/custom_derlight_toast_bar.dart';
import '../../utils/customer_text_field.dart';
import '../../utils/loading_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  //text
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameuserController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //register
  void registerUser() async {
    // Loading
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: SpinKitThreeInOut(
          color: Colors.lightGreenAccent,
          size: 45.0,
        ),
      ),
    );

    try {
      // New account creation
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save user details in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      }

      Navigator.pop(context); // Close loading dialog

      showDialog(
          context: context,
          builder: (context) {
            return MyFancyPopup(
                bodyStyle: const TextStyle(
                    fontFamily: "OpenSans",
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
                heading: "Registration successful!",
                body: "Go to Login page",
                onClose: () {
                  loadingScreen(context, () => const LoginScreen());
                },
                type: Type.success,
                buttonColor: Colors.orangeAccent,
                buttonText: "Continue");
          });

      // // Register success
      // showCustomDelightToastBar(
      //   context,
      //   "Registration successful!",
      // );
      // loadingScreen(context, () => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      // Check email duplication
      if (e.code == 'email-already-in-use') {
        showCustomDelightToastBar(
          context,
          "Account already exists!",
        );
      } else {
        showCustomDelightToastBar(
          context,
          "Register failed: ${e.message}",
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      showCustomDelightToastBar(
        context,
        "Register failed: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Lottie.asset(
                  "assets/Lottie/register.json",
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'RubikWetPaint',
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('IVIVU.COM'),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                CustomTextField(
                  controller: _nameuserController,
                  hintText: "User Name",
                  prefixIcon: Icons.person,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Username is required !"),
                  ]).call,
                ),
                const SizedBox(
                  height: 10,
                ),
                // ),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  validator: MultiValidator([
                    EmailValidator(errorText: "Email error !"),
                    RequiredValidator(errorText: "Email is required !"),
                  ]).call,
                ),
                const SizedBox(
                  height: 10,
                ),
                // ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.key,
                  validator: MultiValidator([
                    MinLengthValidator(6,
                        errorText: "Password must be at least 6 characters"),
                    RequiredValidator(errorText: "Password is required !"),
                  ]).call,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return MyFancyPopup(
                      //           bodyStyle: const TextStyle(
                      //               fontFamily: "OpenSans",
                      //               letterSpacing: 1,
                      //               fontWeight: FontWeight.bold),
                      //           heading: "Đăng nhập thành công !",
                      //           body:
                      //               "Chúng tôi sẽ gửi mã OTP đến số điện thoại của bạn",
                      //           onClose: () {
                      //             Navigator.pop(context);
                      //           },
                      //           type: Type.success,
                      //           buttonColor: Colors.orangeAccent,
                      //           buttonText: "Tiếp tục");
                      //     });
                      registerUser();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: ColorIcon,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Opensans'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              // fontSize: 20,
                              fontFamily: 'OpenSans',
                              color: Colors.black),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          loadingScreen(
                            context,
                            () => const LoginScreen(),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              // fontSize: 23,
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              color: Colors.red),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
