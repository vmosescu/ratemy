import 'package:photo/widgets/ratemy.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RatemyList extends StatefulWidget {
  const RatemyList({super.key});

  @override
  State<RatemyList> createState() {
    return _RatemyListState();
  }
}

class _RatemyListState extends State<RatemyList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('photos')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, photoSnapshot) {
        if (photoSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!photoSnapshot.hasData || photoSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No photos found.'),
          );
        }

        if (photoSnapshot.hasError) {
          return const Center(
            child: Text('Something is wrong with photo database!'),
          );
        }

        final loadedPhotosMeta = photoSnapshot.data!.docs;
        print('snapshot length = ${loadedPhotosMeta.length}');

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: loadedPhotosMeta.length,
          itemBuilder: (ctx, index) {
            final photoMeta = loadedPhotosMeta[index].data();
            return Ratemy(photoMeta: photoMeta);
          },
        );
      },
    );
  }
}
