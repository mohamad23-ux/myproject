import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class editcategory extends StatefulWidget {
  final String? docid;
  final String oldName;

  const editcategory({super.key, this.docid, required this.oldName});

  @override
  State<editcategory> createState() => _editcategoryState();
}

class _editcategoryState extends State<editcategory> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;

  editCategory() async {
    // Call the user's CollectionReference to add a new user
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});

        var response = await categories
            .doc(widget.docid)
            .set({"name": name.text}, SetOptions(merge: false));
        isLoading = false;
        Navigator.of(context).pushNamedAndRemoveUntil(
          "Home",
          (route) => false,
        );
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.text = "";
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 68, 68),
      appBar: AppBar(
        title: Text("add category"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 35, 35),
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: name,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            hintText: " change name",
                            hintStyle: TextStyle(color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'cannot be null';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      editCategory();
                    },
                    color: Colors.red,
                    child: Text(
                      "edit",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
    );
  }
}
