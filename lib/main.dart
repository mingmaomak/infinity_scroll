import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Infinite Scrolling ListView",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PhotosListScreen(),
    );
  }
}

class PhotosListScreen extends StatefulWidget {
  PhotosListScreen({Key key}) : super(key: key);

  @override
  _PhotosListScreenState createState() => _PhotosListScreenState();
}

class _PhotosListScreenState extends State<PhotosListScreen> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  List<Photo> _photos;
  final int _nextPageThreshold = 5;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Star Wars App")),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (_photos.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
          child: InkWell(
            onTap: () => setState(
              () {
                _loading = true;
                _error = false;
                fetchPhotos();
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Error at line 78 while loading photos, tap to try again"),
            ),
          ),
        );
      }
    } else {
      return ListView.builder(
        itemCount: _photos.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _photos.length - _nextPageThreshold) {
            fetchPhotos();
          }
          if (index == _photos.length) {
            if (_error) {
              return Center(
                child: InkWell(
                  onTap: () => setState(
                    () {
                      _loading = true;
                      _error = false;
                      fetchPhotos();
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error at line 103 while loading photos, tap to try again"),
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final Photo photo = _photos[index];
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(
                  // "https://cdn.discordapp.com/attachments/513061527092461570/865428649220767784/pnhx3ba61jt41.jpg",
                  photo.url,
                  fit: BoxFit.fitWidth,
                  width: 300//double.infinity,
                  // height: 160,
                ),
                //   CircleAvatar(
                //     backgroundImage: NetworkImage(photo.url),
                //   ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    photo.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return Container();
  }

  Future<void> fetchPhotos() async {
    try {
      var dio = Dio();
      final response = await dio.get(
          "https://swapi.dev/api/people/?page=$_pageNumber&format=json");
      //List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
      List<Photo> fetchedPhotos = List<Photo>.from(response.data['results'].map((x) => Photo.fromJson(x)));
      setState(
        () {
          _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}

class Photo {
  final String name;
  String url;


  Photo(this.name, this.url);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["name"], json["url"].replaceAll("https://swapi.dev/api/people/", "&").replaceAll("/",".jpg").replaceAll("&", "https://starwars-visualguide.com/assets/img/characters/") );
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}
