import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:photo/screens/add_photo.dart';
import 'package:photo/widgets/ratemy_list.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RatemyList(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        height: 50,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddPhotoScreen(),
                  ),
                );
              },
            ),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app),
                color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
