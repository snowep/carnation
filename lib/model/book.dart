class Book {
  // Main
  final String isbn;
  final String title;
  final List<String> authors; // Remains as a list
  final String synopsis;
  // Details
  final double? width;
  final double? height;
  final String? series;
  final int? volume;
  final int? printing;
  // Credits
  final String? illustrator;
  final String? editor;
  final String? translator;
  final String? coverArtist;
  // Personal
  final String? collectionStatus;
  final int quantity;
  final String? condition;
  final String? location;
  final String? owner;
  // Cover
  final String? coverImageUrl;

  Book({
    required this.title,
    required String authors, // Changed to a single string
    required this.isbn,
    required this.synopsis,
    this.width,
    this.height,
    this.series,
    this.volume,
    this.printing,
    this.illustrator,
    this.editor,
    this.translator,
    this.coverArtist,
    this.collectionStatus,
    required this.quantity,
    this.condition,
    this.location,
    this.owner,
    this.coverImageUrl,
  }) : authors = authors.split(',').map((author) => author.trim()).toList(); // Split the authors string into a list

  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'title': title,
      'authors': authors,
      'synopsis': synopsis,
      'width': width,
      'height': height,
      'series': series,
      'volume': volume,
      'printing': printing,
      'illustrator': illustrator,
      'editor': editor,
      'translator': translator,
      'coverArtist': coverArtist,
      'collectionStatus': collectionStatus,
      'quantity': quantity,
      'condition': condition,
      'location': location,
      'owner': owner,
      'coverImageUrl': coverImageUrl,
    };
  }
}