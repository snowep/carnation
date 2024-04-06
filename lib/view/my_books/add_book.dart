import 'package:carnation/services/firestore_services.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _key = GlobalKey<FormState>();
  final isbnController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_key.currentState!.validate()) {
                FirestoreService().addBook(
                  titleController.text,
                  authorController.text,
                  isbnController.text,
                );
              }
            },
          ),
        
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: isbnController,
                decoration: const InputDecoration(
                  labelText: 'ISBN',
                  hintText: 'Enter the ISBN of the book',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ISBN of the book';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter the title of the book',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title of the book';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  hintText: 'Enter the author of the book',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author of the book';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}