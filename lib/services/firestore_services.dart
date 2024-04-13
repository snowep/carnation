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
      await updateCreditBook(authorId, isbn, 'authors');
    }
    
    await Future.wait([
      updateCreditBook(illustrator as String, isbn, 'illustrators'),
      updateCreditBook(translator as String, isbn, 'translators'),
      updateCreditBook(editor as String, isbn, 'editors'),
      updateCreditBook(coverArtist as String, isbn, 'coverArtists'),
      updateSeriesBook(series, isbn),
    ]);
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
    List<String> words = series.split(' ');
    String initials = words.map((word) => word[0].toUpperCase()).join();
    String seriesId = '$initials-$randomNumber';

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

  Future<void> updateAuthorsBook(String authorId, String isbn) async {
    final authorDocRef = db.collection('authors').doc(authorId);
    await authorDocRef.set({
      'books': FieldValue.arrayUnion([isbn]),
    }, SetOptions(merge: true));
  }

  Future<void> updateCreditBook(String creditId, String isbn, String role) async {
    final creditDocRef = db.collection(role).doc(creditId);
    final docSnapshot = await creditDocRef.get();

    if (docSnapshot.exists) {
      List<String> books = List<String>.from(docSnapshot.data()?['books'] ?? []);
      if (!books.contains(isbn)) {
        await creditDocRef.set({
          'books': FieldValue.arrayUnion([isbn]),
        }, SetOptions(merge: true));
      } else {
        print("ISBN already exists in the books array");
      }
    } else {
      print("Document does not exist");
    }
  }

  Future<void> addCredit(String creditName, String role) async {
    // Split the author's name into first and last name
    List<String> names = creditName.split(' ');
    String firstInitial = names[0][0];
    String middleInitial = '';
    String lastInitial = '';

    if (names.length == 2) {
      lastInitial = names[1][0];
    } else if (names.length > 2) {
      middleInitial = names[1][0];
      lastInitial = names[2][0];
    }

    // Generate a random number
    var rng = Random();
    int randomNumber = rng.nextInt(10000);  // generate a number between 0 and 9999

    // Create a unique ID
    String creditId = '$firstInitial$middleInitial$lastInitial-$randomNumber';

    final creditDocRef = db.collection(role).doc(creditId.toUpperCase());
    await creditDocRef.set({
      'name': creditName,
    }, SetOptions(merge: true));
  }
}