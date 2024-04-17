import 'package:final_project/components/button.dart';
import 'package:final_project/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
        );
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

                  const Text("Welcome back"),

                  const SizedBox(height: 25),

                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false ),

                  const SizedBox(height: 10),

                  MyTextField(controller: passwordController, hintText: 'Password ', obscureText: true ),

                  const SizedBox(height: 10),

                  MyButton(onTap: signIn , text: 'Sign in'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                      child: Text("Register now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)
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
