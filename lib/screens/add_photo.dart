import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:photo/widgets/photo_input.dart';

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
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final uuid = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('photos')
          .child('${user.uid}-$uuid.jpg');

      await storageRef.putFile(_selectedPhoto!);
      final photoUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('photos').add({
        'userId': user.uid,
        'username': userData.data()!['username'],
        'createdAt': Timestamp.now(),
        'photo': photoUrl,
      });
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
