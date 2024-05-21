

import 'package:firebase_learning/firebase_services/loading_service.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  LoadingService loadingScreen = LoadingService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Loading....", style: TextStyle(color: Colors.black),)),
    );
  }
}

