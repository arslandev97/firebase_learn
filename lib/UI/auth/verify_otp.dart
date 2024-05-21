
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/UI/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyOTP extends StatefulWidget {
  final String verificationId;
  const VerifyOTP({super.key, required this.verificationId});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  bool loading = false;
  TextEditingController phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Verify OTP", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: '6 digit code',
              ),
            ),

            const SizedBox(height: 50,),

            RoundButton(
              title: "Verify",
              loading: loading,
              onTap: ()async{

                setState(() {
                  loading = true;
                });

                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: phoneController.text.toString(),
                );

                try{
                  await auth.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const PostScreen()));
                }catch(e){
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage(e.toString());
                }

              },
            ),

            const SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}


