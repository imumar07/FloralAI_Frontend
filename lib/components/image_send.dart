import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({super.key});

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  Uint8List? _imageBytes;
  Map<String, dynamic>? _roseData;
  bool _loading = false;

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
    setState(() {
      _loading = true;
    });
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
    final response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print(response1.body);
      setState(() {
        _roseData = json.decode(response1.body);
        _loading = false;
      });
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
          child: SingleChildScrollView(
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
                        const Icon(
                          Icons.image,
                          size: 300,
                          color: Colors.grey,
                        ),
                      if (_imageBytes == null)
                        const Positioned.fill(
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
                  const SizedBox(height: 20),
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
                          child: const Center(
                            child: Text(
                              "Select Picture",
                              style: TextStyle(
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
                                const SnackBar(
                                  content: Text('Please select an image first'),
                                ),
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Upload Picture",
                              style: TextStyle(
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
                  if (_loading)
                    const CircularProgressIndicator()
                  else if (!_loading && _roseData?.length==1)
                     Text(
                      _roseData!["message"],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  else if (!_loading && _roseData != null && _roseData?.length!=1)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _roseData!["name"],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Habitat: ${_roseData!["habitat"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Scientific Name: ${_roseData!["scientific_name"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Symbolism: ${_roseData!["symbolism"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Interesting Facts:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _roseData!["interesting_facts"]
                                .map<Widget>((fact) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "• $fact",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
