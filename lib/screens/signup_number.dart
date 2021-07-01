import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Home.dart';

class SignUpNumber extends StatefulWidget {
  @override
  _SignUpNumberState createState() => _SignUpNumberState();
}

class _SignUpNumberState extends State<SignUpNumber> {
  TextEditingController NumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String numError = '';

  Future<bool> loginUser(String number) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xff353A85),
        ),
        backgroundColor: Color(0xff353A85),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xff353A85),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.whatshot_rounded,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Business',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "     enter your \n mobile number",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "you will receive a 4 digit code to verify next",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixText: '+91   ',
                        prefixStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20),
                        hintText: 'Contact Number',
                        errorText: numError,
                        contentPadding: EdgeInsets.all(12.8),
                      ),
                      controller: NumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      onChanged: (value) {
                        if (RegExp(r'^\d{10}$').hasMatch(value))
                          setState(() {
                            numError = '';
                          });
                        else
                          setState(() {
                            numError = 'Enter a valid phone number';
                          });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff5D66D3),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListTile(
                title: Text(
                  'Send otp',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                trailing: CircleAvatar(
                  maxRadius: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () {
                      print('+91' + NumberController.value.text.trim());
                      loginUser('+91' + NumberController.value.text.trim());
                    },
                  ),
                  backgroundColor: Color(0xff5D66D3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
