import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> keyframe = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  Future signInWithGoogle() async {
    try {
      isLoading = true;
      await GoogleSignIn().signOut();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; //==========
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      isLoading = false;

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "Home", (route) => false);
      }
    } catch (error) {
      print("error ${error}");
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // إلغاء المستمعات أو العمليات هنا
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 208, 202, 202),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Form(
                    key: keyframe,
                    child: Column(
                      children: [
                        Center(
                          child: Text("Log in with Firebase"),
                        ),
                        Column(
                          children: [Text("Email")],
                        ),
                        Container(
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(22)),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            )),
                        Column(
                          children: [
                            Text("Password"),
                            Container(
                                margin: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(22)),
                                child: TextFormField(
                                  controller: password,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ))
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              if (email.text != "") {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: email.text);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.rightSlide,
                                    title: 'تم ارسال الرابط ',
                                    desc:
                                        'تم ارسال رابط اعداة تعيين كلمة السر الى الايميل الخاص بكم',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                } catch (e) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.rightSlide,
                                    title: 'تحقق من صحة بريدك الالكتروني',
                                    desc: 'بريدك الالكتروني خاطئ',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();

                                  print("erererereeree87878787878787${e}");
                                }
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'ادخل بريدك الالكتروني',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                )..show();
                              }
                            },
                            child: Text("Forget password?..")),
                        MaterialButton(
                          onPressed: () async {
                            if (keyframe.currentState?.validate() ?? false) {
                              try {
                                isLoading = true;
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email.text.trim(),
                                        password: password.text);
                                isLoading = false;
                                setState(() {});

                                if (credential.user!.emailVerified) {
                                  Navigator.pushReplacementNamed(
                                      context, "Home");
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.info,
                                    body: Center(
                                      child: Text(
                                        'توجه الى بريدك الالكتروني والتحقق عن طريق الرابط.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    btnOkOnPress: () {},
                                  ).show();
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.info,
                                    body: Center(
                                      child: Text(
                                        'No user found for that email.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    btnOkOnPress: () {},
                                  ).show();
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      'Wrong password provided for that user.');
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.info,
                                    body: Center(
                                      child: Text(
                                        'Wrong password provided for that user.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    btnOkOnPress: () {},
                                  ).show();
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.info,
                                    body: Center(
                                      child: Text(
                                        'ssomething else error ',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              }
                            }
                          },
                          color: Colors.red,
                          child: Text("Log in"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          color: Colors.red,
                          child: Text("Log in with Google"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () async {
                              Navigator.pushReplacementNamed(context, "signIn");
                            },
                            child: Text("Register a new account")),
                      ],
                    ),
                  ),
                )),
    );
  }
}
