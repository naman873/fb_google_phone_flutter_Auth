import 'package:baliza/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneAuth {
  // final  phoneNo;
  // PhoneAuth({this.phoneNo});

  TextEditingController codeController = TextEditingController();

  Future<bool> loginUser(String number, context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: number,
        verificationCompleted: (AuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);
          User? user = result.user;
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Home();
                },
              ),
            );
          }
        },
        verificationFailed: (exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Given the code"),
                  content: Column(
                    children: [
                      TextField(
                        controller: codeController,
                      )
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () async {
                        final code = codeController.value.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);
                        UserCredential result =
                            await _auth.signInWithCredential(credential);
                        User? user = result.user;
                        print(user);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Home();
                              },
                            ),
                          );
                        }
                      },
                      child: Text('Confirm'),
                      color: Colors.blueAccent,
                      textColor: Colors.white24,
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String code) {});
    return true;
  }
}
