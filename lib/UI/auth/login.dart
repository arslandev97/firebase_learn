
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/UI/auth/signin_with_phone.dart';
import 'package:firebase_learning/UI/auth/signup.dart';
import 'package:firebase_learning/UI/posts/post_screen.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString()
    ).then((onValue){
      setState(() {
        loading = false;
      });
      Utils().toastMessage(onValue.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));

    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Login", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Form(
              key: _formKey,
              child: Column(
                children: [
                  
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      helperText: "enter email e.g john@email.com",
                      suffixIcon: Icon(Icons.email, color: Colors.deepPurple,)
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30.0,),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      suffixIcon: Icon(Icons.lock, color: Colors.deepPurple,)
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Password";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 50.0,),

                ],
              )
            ),

            
        
            RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                if(_formKey.currentState!.validate()){
                  login();
                }
              },
            ),

            const SizedBox(height: 30.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                  }, 
                  child: const Text("Sign up"),
                ),
              ],
            ),

            const SizedBox(height: 50.0,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginWithPhone()));
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: const Center(child: Text("Sign in with Phone Number")),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}

