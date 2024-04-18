import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'delete_button.dart';
import 'like_button.dart';

class WallPost extends StatefulWidget{
  final String message;
  final String user;
  final String postId;

  const WallPost({super.key, required this.message, required this.user, required this.postId,});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  final currentUser = FirebaseAuth.instance.currentUser!;

  void deletePost(){
    showDialog(context: context, builder: (context) => AlertDialog(
     title: const Text('Delete Post'),
     content: const Text('Are you want to delete this post?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'),
        ),
        TextButton(onPressed: () async {
          FirebaseFirestore.instance.collection('User Posts')
              .doc(widget.postId).delete().then((value) => print("Post deleted")).catchError(
                (error) => print("failded to delete post: $error"));
          Navigator.pop(context);
        },
          child: const Text('Delete '),
        ),
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),

          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.red),),
              const SizedBox(height: 10),
              Text(widget.message)
            ],
          )
        ],
      ),
    );
  }
}
