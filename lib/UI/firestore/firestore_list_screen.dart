
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/UI/auth/login.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:flutter/material.dart';

import 'add_firestore_data.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final updatePostController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("users").snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Fire Store Screen", style: TextStyle(color: Colors.white),),
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

          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }

              if(snapshot.hasError){
                return const Text("Some Error MSg");
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]["title"].toString()),
                        subtitle: Text(snapshot.data!.docs[index]["id"].toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  showMyDialog(snapshot.data!.docs[index]["title"].toString(), snapshot.data!.docs[index]["id"].toString());
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("Update"),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  ref.doc(snapshot.data!.docs[index]["id"].toString()).delete();
                                  Navigator.pop(context);
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text("Delete"),
                              ),
                            ),

                          ],),
                      );
                    }),
              );
            },
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddFireStoreDataScreen()));
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id)async{
    updatePostController.text = title;
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: const Border(),
          title: const Text("Update"),
          content: TextField(
            controller: updatePostController,
            decoration: const InputDecoration(
              hintText: "Update Your Text",
            ),
          ),
          actions: [
            TextButton(onPressed: (){ Navigator.pop(context); }, child: const Text("Cancel")),
            TextButton(
              onPressed: (){
                ref.doc(id).update({
                  "title" : updatePostController.text.toString(),
                }).then((value){
                  Utils().toastMessage("Data Updated Successfully");
                  Navigator.pop(context);
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}


