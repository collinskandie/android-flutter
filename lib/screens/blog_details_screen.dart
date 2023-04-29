import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class BlogDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> blogData;

  const BlogDetailsScreen({required this.blogData});

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  late List<dynamic> _blogsList;

  Future<void> _fetchBlogs() async {
    String jsonString = await rootBundle.loadString('assets/blog.json');
    setState(() {
      _blogsList = json.decode(jsonString);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  Future<void> _deleteBlog(int index) async {
    setState(() {
      _blogsList.removeAt(index);
    });
    String jsonStr = json.encode(_blogsList);
    final file = File('assets/blog.json');
    await file.writeAsString(jsonStr).catchError((error) {
      print('Error writing to file: $error');
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: Center(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.blogData['image'],
                fit: BoxFit.cover,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blogData['title'],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.blogData['text'],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Blog'),
                                  content: const Text(
                                      'Are you sure you want to delete this blog?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        int index =
                                            _blogsList.indexOf(widget.blogData);
                                        await _deleteBlog(index);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle edit action
                          },
                          child: const Text('Edit'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
