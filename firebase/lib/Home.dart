import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/category/edit.dart';
import 'package:firebase/main.dart';
import 'package:firebase/note/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 79, 77, 76),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "addCategory");
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text("Welcome!"),
          actions: [
            Center(
              child: IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "logIn", (route) => true);
                  },
                  icon: Icon(Icons.exit_to_app)),
            ),
          ],
        ),
        body: isloading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data.length == 0
                ? Center(
                    child: Text(
                      "YOU HAVE NOT ANY Category",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: 200),
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        noteView(categoryId: data[i].id)));
                          },
                          onLongPress: () {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.warning,
                              title: "Delete Category",
                              body: Center(
                                child: Text(
                                  'هل انت متأكد من الحذف ',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              btnOkColor: Colors.red,
                              btnOkText: 'حذف',
                              btnCancelOnPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => editcategory(
                                        docid: data[i].id,
                                        oldName: data[i]['name'])));
                              },
                              btnCancelText: 'تعديل',
                              btnCancelColor:
                                  const Color.fromARGB(255, 1, 157, 27),
                              btnOkOnPress: () async {
                                print("Ok delete ");
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(data[i].id)
                                    .delete();
                                Navigator.pushNamed(context, 'Home');
                              },
                            ).show();
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 41, 41, 41),
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/folder.png',
                                  height: 150,
                                ),
                                Text(
                                  "${data[i]['name']}",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
