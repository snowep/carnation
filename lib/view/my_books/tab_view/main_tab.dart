import 'package:flutter/material.dart';

class MainTab extends StatefulWidget {
  final TextEditingController isbnController;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController synopsisController;

  const MainTab({
    Key? key,
    required this.isbnController,
    required this.titleController,
    required this.authorController,
    required this.synopsisController,
  }) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.isbnController,
          decoration: const InputDecoration(labelText: 'ISBN'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ISBN';
            }
            return null;
          },
        ),
        TextFormField(
          controller: widget.titleController,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Title';
            }
            return null;
          },
        ),
        TextFormField(
          controller: widget.authorController,
          decoration: const InputDecoration(labelText: 'Author'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Author';
            }
            return null;
          },
        ),
        TextFormField(
          controller: widget.synopsisController,
          decoration: const InputDecoration(labelText: 'Synopsis'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Synopsis';
            }
            return null;
          },
        ),
      ],
    );
  }
}