import 'package:flutter/material.dart';

class DetailsTab extends StatefulWidget {
  final TextEditingController widthController;
  final TextEditingController heightController;
  final TextEditingController seriesController;
  final TextEditingController volumeController;
  final TextEditingController printingController;

  const DetailsTab({
    Key? key,
    required this.widthController,
    required this.heightController,
    required this.seriesController,
    required this.volumeController,
    required this.printingController,
  }) : super(key: key);

  @override
  _DetailsTabState createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> with AutomaticKeepAliveClientMixin {
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
          controller: widget.widthController,
          decoration: const InputDecoration(labelText: 'Width (Optional) (cm)')
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.heightController,
          decoration: const InputDecoration(labelText: 'Height (Optional) (cm)')
        ),
        TextFormField(
          controller: widget.seriesController,
          decoration: const InputDecoration(labelText: 'Series (Optional)')
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.volumeController,
          decoration: const InputDecoration(labelText: 'Volume (Optional)')
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.printingController,
          decoration: const InputDecoration(labelText: 'Printing (Optional)')
        ),
      ],
    );
  }
}