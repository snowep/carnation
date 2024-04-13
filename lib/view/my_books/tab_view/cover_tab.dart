import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
    super.build(context);
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('Pick Image'),
          onPressed: () async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              final filePath = image.path;
              final originalImage = img.decodeImage(File(filePath).readAsBytesSync());

              // Get the file size in bytes
              int fileSizeInBytes = await File(filePath).length();

              // If the file size is larger than 1MB
              if (fileSizeInBytes > 1024 * 1024) {
                // Compress the image
                final compressedImage = img.encodeJpg(originalImage!, quality: 60);

                // Save the compressed image to a new file with .jpg extension
                final dirName = 'compressed_images';
                final fileName = path.basename(filePath).replaceAll(RegExp(r'\.[^\.]+$'), '_compressed.jpg');
                final compressedFilePath = path.join(dirName, fileName);

                final compressedFile = File(compressedFilePath);
                await compressedFile.create(recursive: true);  // Ensure the directory exists
                await compressedFile.writeAsBytes(compressedImage);

                // Create a new XFile from the path of the new file
                final compressedXFile = XFile(compressedFilePath);

                widget.onImagePicked(compressedXFile);
                setState(() {
                  _image = compressedXFile;
                });
              } else {
                // If the file size is less than 1MB, use the original image
                widget.onImagePicked(image);
                setState(() {
                  _image = image;
                });
              }
            }
          },
        ),
        if (_image != null)
          AspectRatio(
            aspectRatio: 1/1.6,
            child: Image.file(
              File(_image!.path),
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}