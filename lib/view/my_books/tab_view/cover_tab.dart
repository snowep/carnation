import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoverTab extends StatefulWidget {
  final Function(XFile) onImagePicked;

  CoverTab({required this.onImagePicked});

  @override
  _CoverTabState createState() => _CoverTabState();
}

class _CoverTabState extends State<CoverTab> with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('Pick Image'),
          onPressed: () async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              widget.onImagePicked(image);
              setState(() {
                _image = image;
              });
            }
          },
        ),
        if (_image != null)
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.file(
              File(_image!.path),
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}