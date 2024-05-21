
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/UI/auth/login.dart';
import 'package:firebase_learning/UI/posts/post_screen.dart';
import 'package:flutter/material.dart';

class LoadingService{

  void isLogin(BuildContext context){

    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(const Duration(seconds: 3), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const PostScreen()));
      });
    }else{
      Timer(const Duration(seconds: 3), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
      });
    }
  }

}

