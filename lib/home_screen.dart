import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> notesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addEditItemBottomSheet(callback: (value) {
                print(value);
                notesList.add(value);
                setState(() {});
              });
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(notesList[index])),
                      IconButton(
                          onPressed: () {
                            addEditItemBottomSheet(
                                initialValue: notesList[index],
                                callback: (val) {
                                  notesList[index] = val;
                                  setState(() {});
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          )),
                      IconButton(
                          onPressed: () {
                            deleteItem(index: index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void deleteItem({required int index}) {
    notesList.removeAt(index);
    setState(() {});
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
                        callback(noteController.text);
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
