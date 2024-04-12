import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsTab extends StatefulWidget {
  final TextEditingController widthController;
  final TextEditingController heightController;
  final TextEditingController seriesController;
  final TextEditingController volumeController;
  final TextEditingController printingController;

  const DetailsTab({
    Key? key,
    required this.widthController,
    required this.heightController,
    required this.seriesController,
    required this.volumeController,
    required this.printingController,
  }) : super(key: key);

  @override
  _DetailsTabState createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> with AutomaticKeepAliveClientMixin {
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
          controller: widget.widthController,
          decoration: const InputDecoration(labelText: 'Width (Optional) (cm)')
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.heightController,
          decoration: const InputDecoration(labelText: 'Height (Optional) (cm)')
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('series').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  List<String> series = snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return data['name'] ?? '';
                  }).toList().cast<String>();

                  return DropdownButtonFormField<String>(
                    value: widget.seriesController.text.isEmpty ? null : widget.seriesController.text,
                    items: series.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.seriesController.text = newValue ?? '';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Series (Optional)'),
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
                    TextEditingController _seriesController = TextEditingController();
                    return AlertDialog(
                      title: Text('Add new series'),
                      content: TextFormField(
                        controller: _seriesController,
                        decoration: const InputDecoration(labelText: 'Series name'),
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
                            if (_seriesController.text.isNotEmpty) {
                              FirebaseFirestore.instance.collection('series').doc(_seriesController.text).set({
                                'name': _seriesController.text,
                              });
                              _seriesController.clear();
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
          keyboardType: TextInputType.number,
          controller: widget.volumeController,
          decoration: const InputDecoration(labelText: 'Volume (Optional)')
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.printingController,
          decoration: const InputDecoration(labelText: 'Printing (Optional)')
        ),
      ],
    );
  }
}