import 'package:carnation/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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

    for (String authorId in book.authors) {
      await updateAuthorsBook(authorId, isbn);
    }

    await updateSeriesBook(series, isbn);
  }

  Future<void> updateSeriesBook(String? series, String isbn) async {
    final seriesDocRef = db.collection('series').doc(series);
    await seriesDocRef.set({
      'books': FieldValue.arrayUnion([isbn]),
    }, SetOptions(merge: true));
  }

  Future<void> addSeries(String series) async {
    // Generate a random number
    var rng = Random();
    int randomNumber = rng.nextInt(10000);  // generate a number between 0 and 9999

    // Create a unique ID
    String seriesId = '$series$randomNumber';

    // Use the unique ID for the new series
    final seriesDocRef = db.collection('series').doc(seriesId);
    await seriesDocRef.set({
      'name': series,
    }, SetOptions(merge: true));
  }

  Future<void> updateBookCoverImageUrl(String isbn, String url) async {
    final bookDocRef = db.collection('books').doc(isbn);
    await bookDocRef.update({'coverImageUrl': url});
  }

  Future<void> addAuthor(String author) async {
    // Split the author's name into first and last name
    List<String> names = author.split(' ');
    String firstInitial = names[0][0];
    String lastInitial = names.length > 1 ? names[1][0] : '';

    // Generate a random number
    var rng = Random();
    int randomNumber = rng.nextInt(10000);  // generate a number between 0 and 9999

    // Create a unique ID
    String authorId = '$firstInitial$lastInitial$randomNumber';

    // Use the unique ID for the new author
    final authorDocRef = db.collection('authors').doc(authorId);
    await authorDocRef.set({
      'name': author,
    }, SetOptions(merge: true));
  }

  Future<void> updateAuthorsBook(String authorId, String isbn) async {
    final authorDocRef = db.collection('authors').doc(authorId);
    await authorDocRef.set({
      'books': FieldValue.arrayUnion([isbn]),
    }, SetOptions(merge: true));
  }
}