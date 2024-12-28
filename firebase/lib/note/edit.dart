import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class editNote extends StatefulWidget {
  final String notedocId;
  final String categorydocId;
  final String value;
  const editNote(
      {super.key,
      required this.notedocId,
      required this.categorydocId,
      required this.value});

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();

  bool isLoading = false;

  editNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categorydocId)
        .collection('note');
    // Call the user's CollectionReference to add a new user
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await collectionNote.doc(widget.notedocId).update({
          "note": note.text,
        });
        isLoading = false;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => noteView(categoryId: widget.notedocId)),
        );
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.value;
    super.initState();
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
        title: Text("edit Note"),
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
                      editNote();
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
