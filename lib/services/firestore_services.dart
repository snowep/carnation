import 'package:carnation/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<bool> bookExists(String isbn) async {
    final docSnapshot = await db.collection('books').doc(isbn).get();
    return docSnapshot.exists;
  }

  Future<void> addBook({
    required String isbn,
    required String title,
    required String authors, // Changed to a string
    required String synopsis,
    double? width,
    double? height,
    String? series,
    int? volume,
    int? printing,
    String? illustrator,
    String? editor,
    String? translator,
    String? coverArtist,
    String? collectionStatus,
    required int quantity,
    String? condition,
    String? location,
    String? owner, 
    String? coverImageUrl,
  }) async {
    if (await bookExists(isbn)) {
      throw Exception('Book already exists');
    } 
    Book book = Book(
      isbn: isbn, 
      title: title,
      authors: authors, // Changed to a string
      synopsis: synopsis,
      width: width,
      height: height,
      series: series,
      volume: volume,
      printing: printing,
      illustrator: illustrator,
      editor: editor,
      translator: translator,
      coverArtist: coverArtist,
      collectionStatus: collectionStatus,
      quantity: quantity,
      condition: condition,
      location: location,
      owner: owner,
      coverImageUrl: coverImageUrl,
    );

    final bookDocRef = db.collection('books').doc(isbn);
    await bookDocRef.set(book.toJson());

    for (String author in book.authors) {
      final authorDocRef = db.collection('authors').doc(author);
      await authorDocRef.set({
        'books': FieldValue.arrayUnion([isbn]),
      }, SetOptions(merge: true));
    }

    final seriesDocRef = db.collection('series').doc(series);
    await seriesDocRef.set({
      'books': FieldValue.arrayUnion([isbn]),
    }, SetOptions(merge: true));


  }

  Future<void> updateBookCoverImageUrl(String isbn, String url) async {
    final bookDocRef = db.collection('books').doc(isbn);
    await bookDocRef.update({'coverImageUrl': url});
  }
}