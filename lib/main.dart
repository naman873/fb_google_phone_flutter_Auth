import 'dart:ui';

import 'package:baliza/Provider/SignInProvider.dart';
import 'package:baliza/screens/Home.dart';
import 'package:baliza/screens/signup_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey _key = GlobalKey();

  Future<UserCredential> signInWithFacebook() async {
    final res = await FacebookAuth.instance.login();
    final fbToken = res.accessToken;

    final facebookAuthCredential =
        FacebookAuthProvider.credential(fbToken!.token);
    print(facebookAuthCredential);
    print(FirebaseAuth.instance.signInWithCredential(facebookAuthCredential));
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  GoogleSignInAccount? _currentUser;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      print('yoo');
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
        _googleSignIn.onCurrentUserChanged
            .listen((GoogleSignInAccount? account) {
          setState(() {
            _currentUser = account;
          });
        });
      });
    } catch (error) {
      print(error);
    }
  }

  void _handleSignOut() {
    _googleSignIn.disconnect();
    setState(
      () {
        _isLoggedIn = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Provider<PhoneAuth>(
      create: (context) => PhoneAuth(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.whatshot_rounded,
                  color: Colors.purple,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Business',
                  style: TextStyle(
                    color: Color(0xff353A85),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "     find your fit \n business  partner",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff353A85),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "join the world's largest business company",
              style: TextStyle(fontSize: 14, color: Color(0xff353A85)),
            ),
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              maxRadius: 30,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(
                  'https://image.shutterstock.com/image-photo/sunset-coast-lake-nature-landscape-260nw-1960131820.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              maxRadius: 40,
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/cd/0c/13/cd0c13629f217c1ab72c61d0664b3f99.jpg'),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'already have account !',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff353A85),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    signInWithFacebook();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Home();
                      }),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'sign in',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xff353A85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _currentUser != null
                          ? ElevatedButton(
                              child: const Text(
                                'Already Login In ! SignOut and LogIn  \n with  different account ?',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                _handleSignOut();
                                setState(() {
                                  _isLoggedIn = false;
                                });
                              },
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 100 / 12.0,
                  child: Container(
                    width: double.infinity,
                    height: 32,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      color: Colors.purple,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpNumber();
                            },
                          ),
                        );
                      },
                      child: Text('Sign up with Number'),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 100 / 12.0,
                  child: Container(
                    width: double.infinity,
                    height: 42,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      color: Colors.grey,
                      onPressed: () async {
                        GoogleSignInAccount? user = _currentUser;
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Home(
                                  user: user,
                                );
                              },
                            ),
                          );
                        } else {
                          await _handleSignIn();
                          //GoogleSignInAccount? user = _currentUser;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Home(
                                  user: _currentUser,
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: Text('Sign up Google'),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 100 / 12.0,
                  child: Container(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      color: Colors.white,
                      onPressed: () async {
                        await signInWithFacebook();
                        //print(FirebaseAuth.instance.currentUser!.uid);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
                        );
                      },
                      child: Text('Sign up with Facebook'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
