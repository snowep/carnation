import 'package:carnation/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  addBook(title, author, isbn) async {
    final docRef = db.collection('books').doc();
    Book book = Book(title: title, author: author, isbn:isbn);

    await docRef.set(book.toJson());
  }
}
