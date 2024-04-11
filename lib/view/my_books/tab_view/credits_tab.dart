import 'package:flutter/material.dart';

class CreditsTab extends StatefulWidget {
  final TextEditingController illustratorController;
  final TextEditingController editorController;
  final TextEditingController translatorController;
  final TextEditingController coverArtistController;

  const CreditsTab({
    Key? key,
    required this.illustratorController,
    required this.editorController,
    required this.translatorController,
    required this.coverArtistController,
  }) : super(key: key);

  @override
  _CreditsTabState createState() => _CreditsTabState();
}

class _CreditsTabState extends State<CreditsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: widget.illustratorController,
          decoration: const InputDecoration(labelText: 'Illustrator (Optional)'),
        ),
        TextFormField(
          controller: widget.editorController,
          decoration: const InputDecoration(labelText: 'Editor (Optional)'),
        ),
        TextFormField(
          controller: widget.translatorController,
          decoration: const InputDecoration(labelText: 'Translator (Optional)'),
        ),
        TextFormField(
          controller: widget.coverArtistController,
          decoration: const InputDecoration(labelText: 'Cover Artist (Optional)'),
        ),
      ],
    );
  }
}