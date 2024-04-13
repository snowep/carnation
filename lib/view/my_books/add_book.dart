import 'dart:io';
import 'dart:math';
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
  void uploadImage(String isbn) async {
    if (pickedImage == null || isbn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Image or ISBN is missing')),
      );
      return;
    }

    // Split the title into words
    List<String> words = titleController.text.split(' ');

    // Get the first letter of each word and make it uppercase
    String firstLetters = words.map((word) => word[0].toUpperCase()).join();

    final rng = Random();
    final randomNumber = rng.nextInt(10000);

    // Create a new file with the desired name
    final newFilePath = pickedImage!.path.replaceFirst(
      RegExp(r'[^/]*$'), 
      '$firstLetters-$randomNumber-cover.jpg'
    ).toUpperCase();
    final newFile = File(newFilePath);

    // Copy the contents of the original file to the new file
    await newFile.writeAsBytes(await File(pickedImage!.path).readAsBytes());

    final Reference storageReference = FirebaseStorage.instance.ref().child('books/${Path.basename(newFile.path)}');
    final UploadTask uploadTask = storageReference.putFile(newFile);

    try {
      final TaskSnapshot downloadUrlSnapshot = await uploadTask.whenComplete(() {});
      final String url = await downloadUrlSnapshot.ref.getDownloadURL();

      await FirestoreService().updateBookCoverImageUrl(isbn, url);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while uploading to Firebase Storage: ${e.message}')),
      );
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
                      uploadImage(isbnController.text);
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
                onImagePicked: (compressedXFile) {
                  setState(() {
                    pickedImage = compressedXFile;
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