import 'package:carnation/view/library/library.dart';
import 'package:carnation/view/my_books/my_books.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<MenuItem> menuItems = [
    MenuItem(label: 'Home', icon: Icons.home, screen: const HomeScreen()),
    MenuItem(label: 'Library', icon: Icons.search_outlined, screen: const LibraryScreen()),
    MenuItem(label: 'Bookshelf', icon: Icons.book, screen: MyBooksScreen()),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menuItems[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        items: menuItems.map((menuItem) => BottomNavigationBarItem(
          icon: Icon(menuItem.icon),
          label: menuItem.label,
        )).toList(),
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class MenuItem {
  final String label;
  final IconData icon;
  final Widget screen; // Reference to the screen widget

  MenuItem({required this.label, required this.icon, required this.screen});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}