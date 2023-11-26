import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> notesList = ["testtesttesttesttesttest testtesttesttesttest testtesttesttest"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showButtomSheet(
                  context: context,
                  callback: (value) {
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
                          onPressed: () {},
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

  void showButtomSheet({required BuildContext context, required Function(String) callback}) {
    TextEditingController noteController = TextEditingController();

    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
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
                  const Expanded(
                      child: Text(
                    "add new note",
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
                  decoration: const InputDecoration(hintText: "Enter New Note", border: OutlineInputBorder()),
                ),
              )
            ],
          );
        });
  }
}
