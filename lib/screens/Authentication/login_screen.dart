import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../utils/colors.dart';
import '../../utils/custom_derlight_toast_bar.dart';
import '../../utils/customer_text_field.dart';
import '../../utils/loading_screen.dart';
import '../main_screen.dart';
import 'forgotpassword_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;
  var formKey = GlobalKey<FormState>();
  //login method

  void login() async {
    // loading
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return MyFancyPopup(
                bodyStyle: const TextStyle(
                    fontFamily: "OpenSans",
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
                heading: "Login successful!",
                body: "Go to Home page",
                onClose: () {
                  loadingScreen(context, () => const Mainscreen());
                },
                type: Type.success,
                buttonColor: Colors.orangeAccent,
                buttonText: "Tiếp tục");
          });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      //truyen email
      Navigator.pushNamed(context, '/profile',
          arguments: _emailController.text);

      // check loi login
      if (e.code == 'user-not-found' && e.code == 'wrong-password') {
        showCustomDelightToastBar(
          context,
          "Incorrect login information",
        );
      } else if (!_formKey.currentState!.validate()) {
        showCustomDelightToastBar(
          context,
          "Please Enter Full Information",
        );
      } else {
        showCustomDelightToastBar(
          context,
          "Wrong Information!",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      loadingScreen(context, () => const RegisterScreen()),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Register >>",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          decorationColor: Colors.black),
                    ),
                  ),
                ),
                Lottie.asset(
                  "assets/Lottie/Animation - 1731402546571.json",
                  height: MediaQuery.of(context).size.height * 0.25,
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
                  height: 20,
                ),
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
                  height: 20,
                ),

                //Forgot password

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        loadingScreen(context, () => ForgotPasswordPage());
                      },
                      child: const Text(
                        "Forgot password !",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      login();
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
                        "Login",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Opensans'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                    Text("OR",
                        style: TextStyle(
                            color: ColorsText,
                            fontSize: 12,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => signInWithFacebook(),
                        child: Image.asset("assets/images/facebook.png")),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Image.asset("assets/images/google.png")),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//login with google
  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        showCustomDelightToastBar(context, "Login in google Successful !");

        //Chuyen scren qa home
        loadingScreen(
          context,
          () => Mainscreen(),
        );
      }
    } catch (e) {
      showCustomDelightToastBar(context, "Login Failed !");
    }
  }

  //login facebook

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(
            '${loginResult.accessToken?.tokenString}');
    //
    showCustomDelightToastBar(context, "Login in facebook Successful !");
    //Chuyen scren qa home
    loadingScreen(
      context,
      () => Mainscreen(),
    );
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
