import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/category/edit.dart';
import 'package:firebase/main.dart';
import 'package:firebase/note/add.dart';
import 'package:firebase/note/edit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class noteView extends StatefulWidget {
  final String categoryId;
  const noteView({super.key, required this.categoryId});

  @override
  State<noteView> createState() => _noteViewState();
}

class _noteViewState extends State<noteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note")
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => addNote(docId: widget.categoryId)));
            },
            backgroundColor: Colors.red,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            title: Text("welcome in note"),
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
          body: PopScope(
            child: isloading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : data.length == 0
                    ? Center(
                        child: Text(
                          "YOU HAVE NOT ANY note in this category",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 200),
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => editNote(
                                        notedocId: data[i].id,
                                        categorydocId: widget.categoryId,
                                        value: data[i]["note"])));
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
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  btnOkColor: Colors.red,
                                  btnOkText: 'حذف',
                                  btnCancelOnPress: () {},
                                  btnCancelText: 'الغاء',
                                  btnCancelColor:
                                      const Color.fromARGB(255, 1, 157, 27),
                                  btnOkOnPress: () async {
                                    print("Ok delete الملاحظة ");
                                    await FirebaseFirestore.instance
                                        .collection('categories')
                                        .doc(widget.categoryId)
                                        .collection('note')
                                        .doc(data[i].id)
                                        .delete();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => noteView(
                                                categoryId:
                                                    widget.categoryId)));
                                  },
                                ).show();
                              },
                              child: Card(
                                color: const Color.fromARGB(255, 41, 41, 41),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${data[i]['note']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 27),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            canPop: false,
            onPopInvoked: (didpop) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("Home", (route) => false);
              return;
            },
          )),
    );
  }
}
