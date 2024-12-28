import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addNote extends StatefulWidget {
  final String docId;
  const addNote({super.key, required this.docId});

  @override
  State<addNote> createState() => _addNoteState();
}

class _addNoteState extends State<addNote> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();

  bool isLoading = false;

  addNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection("note");
    // Call the user's CollectionReference to add a new user
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        DocumentReference response = await collectionNote.add({
          "note": note.text,
        });
        isLoading = false;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => noteView(categoryId: widget.docId)),
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
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 68, 68),
      appBar: AppBar(
        title: Text("add Note"),
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
                        controller: note,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            hintText: "  enter note",
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
                      addNote();
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
