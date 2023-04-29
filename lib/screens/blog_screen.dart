// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './add_blog_screen.dart';
import './blog_details_screen.dart';
import 'package:share/share.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List data;
  final TextEditingController _searchController = TextEditingController();

  Future<String> getData() async {
    String jsonString = await rootBundle.loadString('assets/blogs.json');
    setState(() {
      var jsonData = json.decode(jsonString);
      data = jsonData;
    });
    return "Success";
  }

  void filterPosts(String text) {
    setState(() {
      data = data
          .where((post) =>
              post['title']
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              post['text']
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blogging post"),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    filterPosts(value);
                  },
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(data[index]["image"]),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index]["title"],
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          Text(data[index]["text"],
                              style: const TextStyle(fontSize: 18.0)),
                          const SizedBox(height: 8.0),
                          Text(data[index]["date"],
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.grey)),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlogDetailsScreen(blogData: data[index]),
                                ),
                              );
                            },
                            child: const Text('More Details'),
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              var blogTitle = data[index]["text"];
                              var blogUrl = data[index]["text"];
                              Share.share(
                                'Check out this blog post: $blogTitle\n$blogUrl',
                                subject: 'Blog post shared from MyApp',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size,
                              );
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBlogScreen()),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
