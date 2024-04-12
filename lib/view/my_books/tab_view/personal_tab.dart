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
  bool _isReadOnly = true;
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
          items: [
            {'value': 'Owned', 'icon': Icons.done},
            {'value': 'Borrowed', 'icon': Icons.book},
            {'value': 'Wishlist', 'icon': Icons.favorite_border},
            {'value': 'On Order', 'icon': Icons.shopping_cart}
          ].map((item) {
            return DropdownMenuItem<String>(
              value: item['value'] as String?,
              child: Row(
                children: <Widget>[
                  Icon(item['icon'] as IconData?),
                  const SizedBox(width: 10),  // provides some space between the icon and the text
                  Text(item['value'] as String),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.collectionStatusController.text = newValue!;
              if (newValue == 'Borrowed') {
                _isReadOnly = true;
                widget.ownerController.clear();
              } else {
                _isReadOnly = false;
                widget.ownerController.text = 'Ferdinand';
              }
            });
          },
        ),
        TextFormField(
          keyboardType: TextInputType.number,
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
          enabled: _isReadOnly,
          decoration: const InputDecoration(labelText: 'Owner'),
        ),
      ],
    );
  }
}