import 'package:carnation/view/my_books/add_book.dart';
import 'package:carnation/view/my_books/details/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyBooksScreen extends StatefulWidget {
  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _fetchCount = 11;
  DocumentSnapshot? _lastDocument;
  List<DocumentSnapshot> _documents = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchBooks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchBooks();
    }
  }

  void _fetchBooks() async {
    Query query = FirebaseFirestore.instance.collection('books').orderBy('title').limit(_fetchCount);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      setState(() {
        _documents.addAll(querySnapshot.docs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookshelf'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('books').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final _documents = snapshot.data!.docs;

            return ListView.builder(
              controller: _scrollController,
              itemCount: _documents.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot document = _documents[index];
                final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                final List<String> authorIds = List<String>.from(data['authors'] as List<dynamic>);

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: data),
                      ),
                    );
                  },
                  child: FutureBuilder<List<DocumentSnapshot>>(
                    future: Future.wait(authorIds.map((id) => FirebaseFirestore.instance.collection('authors').doc(id).get()).toList()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> authorDocs = snapshot.data!;
                        String authorsString = authorDocs.map((doc) => (doc.data() as Map<String, dynamic>)['name']).join(', ');

                        return ListTile(
                          title: Text(data['title']),
                          subtitle: Text('$authorsString'),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class MyBooksScreen extends StatefulWidget {
//   const MyBooksScreen({super.key});

//   @override
//   State<MyBooksScreen> createState() => _MyBooksScreenState();
// }

// class _MyBooksScreenState extends State<MyBooksScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final int _fetchCount = 11;
//   DocumentSnapshot? _lastDocument;
//   List<DocumentSnapshot> _documents = [];

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     _fetchBooks();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       _fetchBooks();
//     }
//   }

//   void _fetchBooks() async {
//     Query query = FirebaseFirestore.instance.collection('books').orderBy('title').limit(_fetchCount);
//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }

//     final QuerySnapshot querySnapshot = await query.get();
//     if (querySnapshot.docs.isNotEmpty) {
//       _lastDocument = querySnapshot.docs.last;
//       setState(() {
//         _documents.addAll(querySnapshot.docs);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bookshelf'),
//       ),
//       body: Center(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('books').snapshots(),
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             }

//             return ListView.builder(
//               controller: _scrollController,
//               itemCount: _documents.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final DocumentSnapshot document = _documents[index];
//                 final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => BookDetailsScreen(book: data),
//                       ),
//                     );
//                   },
//                   child: ListTile(
//                     title: Text(data['title']),
//                     subtitle: Text('ISBN: ${data['isbn']}'),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddBookScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }