import 'dart:io';

import 'package:carnation/services/firestore_services.dart';
import 'package:carnation/view/my_books/tab_view/cover_tab.dart';
import 'package:carnation/view/my_books/tab_view/credits_tab.dart';
import 'package:carnation/view/my_books/tab_view/details_tab.dart';
import 'package:carnation/view/my_books/tab_view/main_tab.dart';
import 'package:carnation/view/my_books/tab_view/personal_tab.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  XFile? pickedImage;
  Future<String?> uploadImage() async {
    if (pickedImage == null) return null;

    final Reference storageReference = FirebaseStorage.instance.ref().child('books/${Path.basename(pickedImage!.path)}');
    final UploadTask uploadTask = storageReference.putFile(File(pickedImage!.path));

    try {
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error occurred while uploading to Firebase Storage: $e');
      return null;
    }
  }

  final mainFormKey = GlobalKey<FormState>();
  final detailsFormKey = GlobalKey<FormState>();
  final isbnController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final synopsisController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final seriesController = TextEditingController();
  final volumeController = TextEditingController();
  final printingController = TextEditingController();
  final illustratorController = TextEditingController();
  final editorController = TextEditingController();
  final translatorController = TextEditingController();
  final coverArtistController = TextEditingController();
  final collectionStatusController = TextEditingController();
  final quantityController = TextEditingController();
  final conditionController = TextEditingController();
  final locationController = TextEditingController();
  final ownerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Book'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                if (
                  detailsFormKey.currentState != null &&
                  detailsFormKey.currentState!.validate() && 
                  mainFormKey.currentState != null &&
                  mainFormKey.currentState!.validate()
                ) {
                  try {
                    final bookExists = await FirestoreService().bookExists(isbnController.text);
                    if (bookExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book with this ISBN already exists')),
                      );
                    } else {
                      final String? imageUrl = await uploadImage();
                      // Do something with imageUrl, for example:
                      if (imageUrl != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image uploaded successfully: $imageUrl')),
                        );
                      }

                      await FirestoreService().addBook(
                        isbn: isbnController.text,
                        title: titleController.text,
                        authors: authorController.text,
                        synopsis: synopsisController.text,
                        width: double.tryParse(widthController.text),
                        height: double.tryParse(heightController.text),
                        series: seriesController.text,
                        volume: int.tryParse(volumeController.text),
                        printing: int.tryParse(printingController.text),
                        illustrator: illustratorController.text,
                        editor: editorController.text,
                        translator: translatorController.text,
                        coverArtist: coverArtistController.text,
                        collectionStatus: collectionStatusController.text,
                        quantity: int.tryParse(quantityController.text) ?? 0,
                        condition: conditionController.text,
                        location: locationController.text,
                        owner: ownerController.text,
                        coverImageUrl: imageUrl,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added successfully')),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add book: $e')),
                    );
                  }
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Main'),
              Tab(text: 'Details'),
              Tab(text: 'Credits'),
              Tab(text: 'Cover'),
              Tab(text: 'Personal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Form(
              key: mainFormKey,
              child: MainTab(
                isbnController: isbnController,
                titleController: titleController,
                authorController: authorController,
                synopsisController: synopsisController,
              ),
            ),
            Form(
              key: detailsFormKey,
              child: DetailsTab(
                widthController: widthController,
                heightController: heightController,
                seriesController: seriesController,
                volumeController: volumeController,
                printingController: printingController,
              ),
            ),
            Form(
              child: CreditsTab(
                illustratorController: illustratorController,
                editorController: editorController,
                translatorController: translatorController,
                coverArtistController: coverArtistController,
              ),
            ),
            Form(
              child: CoverTab(
                onImagePicked: (image) {
                  setState(() {
                    pickedImage = image;
                  });
                },
              ),
            ),
            Form(
              child: PersonalTab(
                collectionStatusController: collectionStatusController,
                quantityController: quantityController,
                conditionController: conditionController,
                locationController: locationController,
                ownerController: ownerController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}