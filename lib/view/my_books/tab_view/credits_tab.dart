import 'package:carnation/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreditsTab extends StatefulWidget {
  final TextEditingController illustratorController;
  final TextEditingController editorController;
  final TextEditingController translatorController;
  final TextEditingController coverArtistController;

  const CreditsTab({
    Key? key,
    required this.illustratorController,
    required this.editorController,
    required this.translatorController,
    required this.coverArtistController,
  }) : super(key: key);

  @override
  _CreditsTabState createState() => _CreditsTabState();
}

class _CreditsTabState extends State<CreditsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('illustrators').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<Map<String, dynamic>> illustrators = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return {
                      'id': document.id,
                      'name': data['name'] ?? ''
                    };
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: widget.illustratorController.text.isEmpty ? null : widget.illustratorController.text,
                    items: illustrators.map<DropdownMenuItem<String>>((illustrator) {
                      return DropdownMenuItem<String>(
                        value: illustrator['id'],
                        child: Text(illustrator['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.illustratorController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Illustrator (Optional)'),
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
                    return AddCreditDialog(
                      title: 'illustrator',
                      collection: 'illustrators',
                      controller: widget.illustratorController,
                    );
                  },
                );
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('translators').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<Map<String, dynamic>> translators = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return {
                      'id': document.id,
                      'name': data['name'] ?? ''
                    };
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: widget.translatorController.text.isEmpty ? null : widget.translatorController.text,
                    items: translators.map<DropdownMenuItem<String>>((translator) {
                      return DropdownMenuItem<String>(
                        value: translator['id'],
                        child: Text(translator['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.translatorController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Translator (Optional)'),
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
                    return AddCreditDialog(
                      title: 'translator',
                      collection: 'translators',
                      controller: widget.translatorController,
                    );
                  },
                );
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('editors').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<Map<String, dynamic>> editors = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return {
                      'id': document.id,
                      'name': data['name'] ?? ''
                    };
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: widget.editorController.text.isEmpty ? null : widget.editorController.text,
                    items: editors.map<DropdownMenuItem<String>>((editor) {
                      return DropdownMenuItem<String>(
                        value: editor['id'],
                        child: Text(editor['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.editorController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Editor (Optional)'),
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
                    return AddCreditDialog(
                      title: 'editor',
                      collection: 'editors',
                      controller: widget.editorController,
                    );
                  },
                );
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('coverArtists').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<Map<String, dynamic>> coverArtists = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return {
                      'id': document.id,
                      'name': data['name'] ?? ''
                    };
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: widget.coverArtistController.text.isEmpty ? null : widget.coverArtistController.text,
                    items: coverArtists.map<DropdownMenuItem<String>>((coverArtist) {
                      return DropdownMenuItem<String>(
                        value: coverArtist['id'],
                        child: Text(coverArtist['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.coverArtistController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Cover Artist (Optional)'),
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
                    return AddCreditDialog(
                      title: 'cover artist',
                      collection: 'coverArtists',
                      controller: widget.coverArtistController,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class AddCreditDialog extends StatelessWidget {
  final String title;
  final String collection;
  final TextEditingController controller;

  AddCreditDialog({required this.title, required this.collection, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new $title'),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: '$title name'),
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
            if (controller.text.isNotEmpty) {
              firestoreService.addCredit(controller.text, collection);
              controller.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}