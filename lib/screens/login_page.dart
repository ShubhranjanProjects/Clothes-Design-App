import 'package:countries_of_the_world/screens/home_screen.dart';
import 'package:countries_of_the_world/screens/signup_page.dart';
import 'package:countries_of_the_world/screens/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signIn(String email, String password) async {
    if (email == "" && password == "") {
      return UiHelper.alertBoxHelper(context, 'Enter required fields!');
    } else {
      try {
        UserCredential? userCredential;
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DesignScreen()));
        });
      } on FirebaseAuthException catch (e) {
        return UiHelper.alertBoxHelper(context, e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Icon(Icons.map)),
      body: Column(
        children: [
          const Text(
            'SIGN IN',
            style: TextStyle(fontSize: 20),
          ),
          const Text(
            'Login to Dashboard account',
            style: TextStyle(fontSize: 18),
          ),
          Text.rich(TextSpan(text: "Don't have an account? ", children: [
            TextSpan(
                text: "Register",
                style: const TextStyle(color: Colors.lightBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  })
          ])),
          UiHelper.CustomInputField(
              emailController, const Icon(Icons.mail), 'EMAIL', false),
          UiHelper.CustomInputField(
              passwordController, const Icon(Icons.password), 'PASSWORD', true),
          ElevatedButton(
            onPressed: () {
              signIn(emailController.text.toString(),
                  passwordController.text.toString());
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Colors.deepPurpleAccent),
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
