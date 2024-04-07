import 'package:carnation/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  addBook(
    // Main
    isbn,
    title,
    author,
    synopsis,
    // Details
    [
      String? width,
      String? height,
      String? series,
      String? volume,
      String? printing
    ]
  ) async {
    final docRef = db.collection('books').doc();
    Book book = Book(
      isbn: isbn, 
      title: title,
      author: author,
      synopsis: synopsis,
      width: width,
      height: height,
      series: series,
      volume: volume,
      printing: printing
    );

    await docRef.set(book.toJson());

    print(title);
  }
}
