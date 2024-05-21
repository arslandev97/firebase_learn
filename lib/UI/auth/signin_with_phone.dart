
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/UI/auth/verify_otp.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {

  bool loading = false;
  TextEditingController phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Verify Phone Number", style: TextStyle(color: Colors.white),),
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
                hintText: '+1 234 3455 234',
              ),
            ),

            const SizedBox(height: 50,),

            RoundButton(
              title: "Send OTP Code",
              loading: loading,
              onTap: (){

                setState(() {
                  loading = true;
                });

                auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text.toString(),
                    verificationCompleted: (_){
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e){
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (String verificationId, int? token){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyOTP(verificationId: verificationId,)));
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e){
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                );

              },
            ),

            const SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}

