import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/drawer.dart';
import 'package:final_project/components/text_field.dart';
import 'package:final_project/components/wall_post.dart';
import 'package:final_project/pages/profile_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser  = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage(){
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }
    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Wall'),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder (
            stream: FirebaseFirestore.instance.collection('User Posts').orderBy("TimeStamp",descending: false).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(itemCount:snapshot.data!.docs.length, itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  return WallPost(message: post['Message'], user: post['UserEmail']
                  );
                }
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error}'),
                );
              }
              return const Center(child: CircularProgressIndicator(),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(child: MyTextField(
                  controller: textController,
                  hintText: 'Write something on the wall',
                  obscureText: false,
                )
                ),
                IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
              ],
            ),
          ),

          Text("Logged in as: " + currentUser.email!,
          style: TextStyle(color: Colors.blueAccent),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
