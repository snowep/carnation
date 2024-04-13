import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Unknown Title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book['coverImageUrl'] != null)
              Image.network(book['coverImageUrl']),
            ...book.entries.map((entry) {
              if (entry.value != null) {
                return Text('${entry.key}: ${entry.value}');
              } else {
                return Container(); // Return an empty container if the value is null
              }
            }).toList(),
          ],
        ),
      ),
    );
  }
}