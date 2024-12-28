import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  GlobalKey keyframe = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Form(
            key: keyframe,
            child: Column(
              children: [
                Center(
                  child: Text("Sign in with Firebase"),
                ),
                Column(
                  children: [
                    Text("USERNAME"),
                  ],
                ),
                Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(22)),
                    child: TextFormField(
                      controller: username,
                    )),
                Text("Email"),
                Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(22)),
                    child: TextFormField(
                      controller: email,
                    )),
                Column(
                  children: [
                    Text("password"),
                    Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(22)),
                        child: TextFormField(
                          controller: password,
                        ))
                  ],
                ),
                TextButton(onPressed: () {}, child: Text("Forget password?..")),
                MaterialButton(
                  onPressed: () async {
                    try {
                      isLoading = true;
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text,
                      );
                      isLoading = false;
                      setState(() {});
                    } on FirebaseAuthException catch (e) {
                      isLoading = true;
                      setState(() { });
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Dialog Title',
                          desc: 'Dialog description here.............',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        )..show();
                      } else if (e.code == 'email-already-in-use') {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.info,
                          body: Center(
                            child: Text(
                              'email is already in use ',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          btnOkOnPress: () {},
                        ).show();
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'تم ارسال بريد التحقق',
                      desc:
                          'توجه الى بريدك الالكتروني وانقر على الرابط للتحقق من بريدك',
                      btnOkOnPress: () {
                        Navigator.pushReplacementNamed(context, "lopIn");
                      },
                    )..show();
                  },
                  color: Colors.red,
                  child: Text("SIGN IN "),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, "logIn");
                  },
                  color: Colors.red,
                  child: Text("back "),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
