import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  Uint8List? _imageBytes;

  void _pickImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.click();

    input.onChange.listen((event) async {
      final files = input.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        reader.onLoadEnd.listen((event) {
          final result = reader.result;
          if (result is Uint8List) {
            setState(() {
              _imageBytes = result;
            });
          } else if (result is Uint8List) {
            setState(() {
              _imageBytes = Uint8List.view(result as ByteBuffer);
            });
          }
        });
      }
    });
  }

  Future<void> _uploadImage(Uint8List imageBytes) async {
    final url = Uri.parse('http://localhost:8080/upload');

    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile(
      'image', // This should match the backend's expected file name
      http.ByteStream.fromBytes(imageBytes),
      imageBytes.length,
      filename: 'image.jpg', // You can adjust the filename if needed
      contentType: MediaType('image',
          'jpeg'), // Adjust content type based on the actual image type
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      print("Image sent successfully");
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  if (_imageBytes != null)
                    Image.memory(
                      _imageBytes!,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    )
                  else
                    Icon(
                      Icons.image,
                      size: 300,
                      color: Colors.grey,
                    ),
                  if (_imageBytes == null)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Please insert image',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 120),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: _pickImage,
                      child: Center(
                        child: Text(
                          "Select Picture",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 120),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_imageBytes != null) {
                          _uploadImage(_imageBytes!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an image first'),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          "Upload Picture",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
