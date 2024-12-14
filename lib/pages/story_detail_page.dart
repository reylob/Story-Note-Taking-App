import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryDetailPage extends StatelessWidget {
  final Story story;

  StoryDetailPage({required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          story.content,
          style: TextStyle(fontSize: 18.0, height: 1.5),
        ),
      ),
    );
  }
}
