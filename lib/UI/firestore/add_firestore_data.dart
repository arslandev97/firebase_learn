
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {

  TextEditingController postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Add Fire store Data", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.logout),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [

            const SizedBox(height: 50.0,),

            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What is in your mind?",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 50.0,),

            RoundButton(
              title: "Add",
              loading: loading,
              onTap: (){

                setState(() {
                  loading = true;
                });

                String id = DateTime.now().microsecondsSinceEpoch.toString();

                fireStore.doc(id).set({

                  "title" : postController.text.toString(),
                  "id": id,

                }).then((value){

                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage("Data Added Successfully");

                  postController.text = "";

                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());

                });


              },
            ),

          ],
        ),
      ),
    );
  }
}

