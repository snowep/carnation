class Book {
  final String isbn;
  final String title;
  final String author;

  const Book({required this.title, required this.author, required this.isbn});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
    };
  }
}
