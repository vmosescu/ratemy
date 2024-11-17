import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Ratemy extends StatefulWidget {
  const Ratemy({super.key, required this.photoRef});

  final Reference photoRef;

  @override
  State<Ratemy> createState() {
    return _RatemyState();
  }
}

class _RatemyState extends State<Ratemy> {
  var _isLoading = true;
  var _photoUrl = '';
  void loadPhotoUrl() async {
    _photoUrl = await widget.photoRef.getDownloadURL();
    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPhotoUrl();
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Image(
        image: NetworkImage(_photoUrl),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
