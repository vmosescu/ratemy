import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:fashion/widgets/ratemy.dart';

class RatemyList extends StatefulWidget {
  const RatemyList({super.key});
  @override
  State<RatemyList> createState() {
    return _RatemyListState();
  }
}

class _RatemyListState extends State<RatemyList> {
  final _photosRef = FirebaseStorage.instance.ref().child('photos');
  String? _token;
  final _controller = StreamController<ListResult>();
  var _indexer = 0;

  void listPhotos() async {
    final listResult = await _photosRef.list(ListOptions(
      maxResults: 2,
      pageToken: _token,
    ));
    print('$_token');
    _token = listResult.nextPageToken;
    _controller.add(listResult);
  }

  void loadPhotos() {
    print('addItems');
    _indexer = 0;
    listPhotos();
  }

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    Widget noContent(String msg) {
      return Center(child: Text(msg));
    }

    return StreamBuilder(
      stream: _controller.stream,
      builder: (ctx, snapshot) {
        print('snapshot.hasData ${snapshot.hasData}');
        if (!snapshot.hasData) {
          return noContent('snapshot');
        }

        List<Reference> lista = snapshot.data!.items;
        print('length=${lista.length}');

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) {
            print('indexer ${_indexer}');
            if (_indexer >= lista.length) {
              loadPhotos();
              return const Center(
                child: Text('loading'),
              );
            }
            return Ratemy(photoRef: lista[_indexer++]);
          },
        );
      },
    );
  }
}
