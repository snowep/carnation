class Book {
  final String isbn;
  final String title;
  final String author;
  final String synopsis;
  String? width;
  String? height;
  String? series;
  String? volume;
  String? printing;


  Book({
    required this.title,
    required this.author,
    required this.isbn,
    required this.synopsis,
    this.width,
    this.height,
    this.series,
    this.volume,
    this.printing,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'synopsis': synopsis,
      'width': width,
      'height': height,
      'series': series,
      'volume': volume,
    };
  }
}
