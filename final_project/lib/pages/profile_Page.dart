import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection("users");

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text("Edit $field", style: const TextStyle(color: Colors.white),
      ),
    content: TextField(
      autofocus: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Enter new $field",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (value) {
        newValue = value;
      },
    ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Save', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.of(context).pop(newValue),
        ),
      ],
    ),
    );

    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.person, size: 72,),
                  const SizedBox(height: 10),
                  Text(currentUser.email!, textAlign: TextAlign.center),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text('My Details'),
                  ),
                  MyTextBox(text: userData['username'], sectionName: 'username', onPressed: () => editField('username'),
                  ),
                  MyTextBox(text: userData['bio'], sectionName: 'bio', onPressed: () => editField('bio'),
                  ),
                  const SizedBox(height: 50),
                  Padding(padding: const EdgeInsets.only(left: 25.0),
                  child: Text('My Posts'),
                  ),
                ],
              );
            }else if (snapshot.hasError) {
              return Center(child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
