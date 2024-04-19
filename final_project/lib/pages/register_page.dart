import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget{
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void signUp() async {

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));
    if(passwordController.text != confirmpasswordController.text) {
      Navigator.pop(context);
      displayMessage("Password don't match");
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );

      FirebaseFirestore.instance.collection("users")
          .doc(userCredential.user!.email)
          .set({'username': emailController.text.split("@")[0],
                'bio' : 'Empty bio..'
          });
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }

  }
  void displayMessage(String message) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(message),));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column( mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Icon(Icons.lock_open_rounded, size: 100),

                      const SizedBox(height: 50),

                      const Text("Create your account"),

                      const SizedBox(height: 25),

                      MyTextField(controller: emailController, hintText: 'Email', obscureText: false ),

                      const SizedBox(height: 10),

                      MyTextField(controller: passwordController, hintText: 'Password', obscureText: true ),

                      const SizedBox(height: 10),

                      MyTextField(controller: confirmpasswordController, hintText: 'Confirm Password', obscureText: true ),

                      const SizedBox(height: 10),

                      MyButton(onTap: signUp, text: 'Sign up'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("already have an account?"),
                          const SizedBox(width: 4),
                          GestureDetector(
                              onTap: widget.onTap,
                              child: Text("Login here", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}



