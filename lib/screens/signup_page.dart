import 'package:countries_of_the_world/screens/login_page.dart';
import 'package:countries_of_the_world/screens/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signUp(String email, String password) async {
    if (email == "" && password == "") {
      UiHelper.alertBoxHelper(context, 'Enter required fields!');
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
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
            'REGISTER',
            style: TextStyle(fontSize: 20),
          ),
          const Text(
            'Login to Dashboard account',
            style: TextStyle(fontSize: 18),
          ),
          Text.rich(TextSpan(text: "Already have an account? ", children: [
            TextSpan(
                text: "Sign-in",
                style: const TextStyle(color: Colors.lightBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  })
          ])),
          UiHelper.CustomInputField(
              emailController, const Icon(Icons.mail), 'EMAIL', false),
          UiHelper.CustomInputField(
              passwordController, const Icon(Icons.password), 'PASSWORD', true),
          // UiHelper.CustomInputField(passwordController,
          //     const Icon(Icons.password), 'CONFIRM PASSWORD', true),
          ElevatedButton(
            onPressed: () {
              signUp(emailController.text.toString(),
                  passwordController.text.toString());
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Colors.deepPurpleAccent),
            ),
            child: const Text(
              'Register',
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
