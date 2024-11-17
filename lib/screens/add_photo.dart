import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:fashion/widgets/photo_input.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<AddPhotoScreen> createState() {
    return _AddPhotoScreenState();
  }
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  File? _selectedPhoto;
  var _isUploading = false;

  void _addPhoto() async {
    if (_selectedPhoto == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final uuid = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('photos')
          .child('${user!.uid}-$uuid.jpg');

      await storageRef.putFile(_selectedPhoto!);
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Upload photo failed.')));
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            PhotoInput(
              onPickPhoto: (pickedPhoto) {
                _selectedPhoto = pickedPhoto;
              },
            ),
            const SizedBox(height: 16),
            if (_isUploading) const CircularProgressIndicator(),
            if (!_isUploading)
              ElevatedButton.icon(
                onPressed: _addPhoto,
                icon: const Icon(Icons.add),
                label: const Text('Add Photo'),
              )
          ],
        ),
      ),
    );
  }
}
