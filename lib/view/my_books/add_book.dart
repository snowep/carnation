import 'package:carnation/services/firestore_services.dart';
import 'package:carnation/view/my_books/tab_view/credits_tab.dart';
import 'package:carnation/view/my_books/tab_view/details_tab.dart';
import 'package:carnation/view/my_books/tab_view/main_tab.dart';
import 'package:carnation/view/my_books/tab_view/personal_tab.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
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
              onPressed: () {
                if (
                  detailsFormKey.currentState != null &&
                  detailsFormKey.currentState!.validate() && 
                  mainFormKey.currentState != null &&
                  mainFormKey.currentState!.validate()
                ) {
                  FirestoreService().addBook(
                    // Main
                    isbnController.text,
                    titleController.text,
                    authorController.text,
                    synopsisController.text,
                    // Details
                    widthController.text,
                    heightController.text,
                    seriesController.text,
                    volumeController.text,
                    printingController.text
                  );
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
            const Center(child: Text('Cover')),
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