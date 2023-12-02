import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('todo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addEditItemBottomSheet(callback: (value) async {
                print(value);

                await _collection.add({"note": value});

                //  notesList.add(value);
                // setState(() {});
              });
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: _collection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child: Text(documentSnapshot['note'])),
                              IconButton(
                                  onPressed: () {
                                    addEditItemBottomSheet(
                                        initialValue: documentSnapshot['note'],
                                        callback: (val) async {
                                          await _collection.doc(documentSnapshot.id).update({"note": val});
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  )),
                              IconButton(
                                  onPressed: () => deleteItem(documnetId: documentSnapshot.id),
                                  // onPressed: () {
                                  //   deleteItem(documnetId: documentSnapshot.id);
                                  // },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void deleteItem({required String documnetId}) {
    _collection.doc(documnetId).delete();
  }

  void addEditItemBottomSheet({String? initialValue, required Function(String) callback}) {
    TextEditingController noteController = TextEditingController();

    if (initialValue != null) {
      //ma3nahaa edit
      noteController.text = initialValue;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                  Expanded(
                      child: Text(
                    initialValue != null ? "Edit note" : "Add new Note",
                    textAlign: TextAlign.center,
                  )),
                  TextButton(
                      onPressed: () {
                        if (noteController.text.isEmpty == false) {
                          callback(noteController.text);
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text("Save")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                      hintText: initialValue != null ? "Edit Note" : "Add Note", border: const OutlineInputBorder()),
                ),
              )
            ],
          );
        });
  }
}
