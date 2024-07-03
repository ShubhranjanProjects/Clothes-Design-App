import 'dart:typed_data';
import 'package:countries_of_the_world/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class DesignScreen extends StatefulWidget {
  @override
  _DesignScreenState createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? _baseImage;
  Uint8List? _clothesImage;
  String? _resultImageUrl;
  bool _isLoading = false;
  final TextEditingController _categoryController = TextEditingController();

  Future<void> _pickBaseImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _baseImage = result.files.single.bytes;
      });
    }
  }

  Future<void> _pickClothesImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _clothesImage = result.files.single.bytes;
      });
    }
  }

  Future<void> _swapClothes() async {
    if (_baseImage == null ||
        _clothesImage == null ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please upload both images and enter a category')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest('POST',
        Uri.parse('https://web-production-27e6.up.railway.app/swap-clothes'));
    request.fields['category'] = _categoryController.text;
    request.files.add(http.MultipartFile.fromBytes('person_image', _baseImage!,
        filename: 'base_image.png'));
    request.files.add(http.MultipartFile.fromBytes(
        'clothes_design', _clothesImage!,
        filename: 'clothes_image.png'));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final responseJson = json.decode(responseData);
        setState(() {
          _resultImageUrl = responseJson['url'];
        });
      } else {
        final responseData = await response.stream.bytesToString();
        print('HTTP ${response.statusCode} ${response.reasonPhrase}');
        print('Response data: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to swap clothes: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _clearBaseImage() {
    setState(() {
      _baseImage = null;
    });
  }

  void _clearClothesImage() {
    setState(() {
      _clothesImage = null;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0E5EB6),
        title: Text(
          'Design App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clothes Swap with Stable Diffusion',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            Text(
              'Upload the base image and the clothes design image to swap clothes.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Text(
              'Upload Base Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickBaseImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _baseImage != null
                        ? Image.memory(_baseImage!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                                'Drag and drop file here\nLimit 200MB per file • PNG, JPG, JPEG',
                                textAlign: TextAlign.center)),
                  ),
                ),
                if (_baseImage != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: _clearBaseImage,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Upload Clothes Design Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickClothesImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _clothesImage != null
                        ? Image.memory(_clothesImage!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                                'Drag and drop file here\nLimit 200MB per file • PNG, JPG, JPEG',
                                textAlign: TextAlign.center)),
                  ),
                ),
                if (_clothesImage != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: _clearClothesImage,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text('Enter the category - upper_body or lower_body or dresses'),
            SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter category',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _swapClothes,
                child: Text('Swap Clothes'),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_resultImageUrl != null)
              Column(
                children: [
                  Text('Result:'),
                  SizedBox(height: 10),
                  Image.network(_resultImageUrl!),
                ],
              )
            else
              Text('Please upload both images and category to swap clothes.'),
          ],
        ),
      ),
    );
  }
}
