import 'package:carnation/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainTab extends StatefulWidget {
  final TextEditingController isbnController;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController synopsisController;

  const MainTab({
    Key? key,
    required this.isbnController,
    required this.titleController,
    required this.authorController,
    required this.synopsisController,
  }) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.isbnController,
          decoration: const InputDecoration(labelText: 'ISBN'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ISBN';
            }
            return null;
          },
        ),
        TextFormField(
          controller: widget.titleController,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Title';
            }
            return null;
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('authors').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<Map<String, dynamic>> authors = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return {
                      'id': document.id,
                      'name': data['name'] ?? ''
                    };
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: widget.authorController.text.isEmpty ? null : widget.authorController.text,
                    items: authors.map<DropdownMenuItem<String>>((author) {
                      return DropdownMenuItem<String>(
                        value: author['id'],
                        child: Text(author['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.authorController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Author'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Author';
                      }
                      return null;
                    },
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController _authorController = TextEditingController();
                    return AlertDialog(
                      title: Text('Add new author'),
                      content: TextFormField(
                        controller: _authorController,
                        decoration: const InputDecoration(labelText: 'Author name'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Add'),
                          onPressed: () {
                            FirestoreService firestoreService = FirestoreService();
                            if (_authorController.text.isNotEmpty) {
                              firestoreService.addCredit(_authorController.text, 'authors');
                              _authorController.clear();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        TextFormField(
          minLines: 6,
          maxLines: 20,
          controller: widget.synopsisController,
          decoration: const InputDecoration(labelText: 'Synopsis'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Synopsis';
            }
            return null;
          },
        ),
      ],
    );
  }
}