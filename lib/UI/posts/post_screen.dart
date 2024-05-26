
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
  final searchFilter = TextEditingController();
  final updatePostController = TextEditingController();

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
          
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
          //       if(!snapshot.hasData){
          //         return const CircularProgressIndicator();
          //       }else{
          //
          //         Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //
          //
          //         return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index){
          //               return ListTile(
          //                 title: Text(list[index]['title']),
          //                 subtitle: Text(list[index]['id']),
          //               );
          //             });
          //       }
          //
          //     },
          //   ),
          // ),
          // const Divider(),

          // Search Filter

          const SizedBox(height: 20.0,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          const SizedBox(height: 20.0,),

          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text("Loading..."),
              itemBuilder: (context, snapshot, animation, index){

                final title = snapshot.child("title").value.toString();

                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child("id").value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: (){
                              ref.child(snapshot.child("id").value.toString()).remove();
                              Navigator.pop(context);
                            },
                            leading: const Icon(Icons.delete),
                            title: const Text("Delete"),
                          ),
                        ),
                      ],

                    ),
                  );
                }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toString())){
                  return ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                  );
                }else{
                  return Container();
                }

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
                ref.child(id).update({
                  'title' : updatePostController.text.toString(),
                }).then((onValue){
                  Utils().toastMessage("Post Updated Successfully");
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


