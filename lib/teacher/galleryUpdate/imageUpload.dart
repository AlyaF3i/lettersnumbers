import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  String _title = '';
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();


  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
      await storageRef.putFile(_image!);

      // Get image URL
      String imageUrl = await storageRef.getDownloadURL();

      // Save details to Firestore
      await FirebaseFirestore.instance.collection('photos').add({
        'title': _title,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
        _image = null;
        _title = '';
      });
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                getImage();
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _image == null || _title.isEmpty || _isUploading
                  ? null
                  : _uploadImage,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }


   Future getImage() async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
        setState(() {
          _image = File(image!.path);
        });
      }
}

