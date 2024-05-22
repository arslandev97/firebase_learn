
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_learning/UI/auth/login.dart';
import 'package:firebase_learning/UI/posts/add_posts.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Post Screen", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [

          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text("Loading..."),
              itemBuilder: (context, snapshot, animation, index){
                return ListTile(
                  title: Text(snapshot.child("title").value.toString()),
                  subtitle: Text(snapshot.child("id").value.toString()),
                );
              },
            
            ),
          ),

          

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddPostScreen()));
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}


