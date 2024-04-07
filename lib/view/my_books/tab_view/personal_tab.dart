import 'package:flutter/material.dart';

class PersonalTab extends StatefulWidget {
  final TextEditingController collectionStatusController;
  final TextEditingController quantityController;
  final TextEditingController conditionController;
  final TextEditingController locationController;
  final TextEditingController ownerController;

  const PersonalTab({
    Key? key,
    required this.collectionStatusController,
    required this.quantityController,
    required this.conditionController,
    required this.locationController,
    required this.ownerController,
  }) : super(key: key);

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> with AutomaticKeepAliveClientMixin {
  String? _selectedCollectionStatus;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField(
          value: _selectedCollectionStatus,
          decoration: const InputDecoration(labelText: 'Collection Status'),
          items: ['Owned', 'Wishlist', 'Borrowed'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.collectionStatusController.text = newValue!;
            });
          },
        ),
        TextFormField(
          controller: widget.quantityController,
          decoration: const InputDecoration(labelText: 'Quantity'),
        ),
        TextFormField(
          controller: widget.conditionController,
          decoration: const InputDecoration(labelText: 'Condition'),
        ),
        TextFormField(
          controller: widget.locationController,
          decoration: const InputDecoration(labelText: 'Location'),
        ),
        TextFormField(
          controller: widget.ownerController,
          decoration: const InputDecoration(labelText: 'Owner'),
        ),
      ],
    );
  }
}