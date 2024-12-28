import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addCategory extends StatefulWidget {
  const addCategory({super.key});

  @override
  State<addCategory> createState() => _addCategoryState();
}

class _addCategoryState extends State<addCategory> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;

  addCategory() async {
    // Call the user's CollectionReference to add a new user
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        DocumentReference response = await categories.add({
          "name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        });
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
                            hintText: "  enter name",
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
                      addCategory();
                    },
                    color: Colors.red,
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
    );
  }
}
