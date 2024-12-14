import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';
import 'story_detail_page.dart';
import 'add_story_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Story> stories = [];

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  // Load stories from shared_preferences
  Future<void> loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final storiesData = prefs.getString('stories') ?? '[]';
    final List<dynamic> storiesJson = jsonDecode(storiesData);

    setState(() {
      stories = storiesJson.map((json) => Story.fromJson(json)).toList();
    });
  }

  // Save stories to shared_preferences
  Future<void> saveStories() async {
    final prefs = await SharedPreferences.getInstance();
    final storiesJson = stories.map((story) => story.toJson()).toList();
    prefs.setString('stories', jsonEncode(storiesJson));
  }

  // Add a new story
  void addStory(Story story) {
    setState(() {
      stories.add(story);
    });
    saveStories();
  }

  // Delete a story
  void deleteStory(int index) {
    setState(() {
      stories.removeAt(index);
    });
    saveStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                story.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteStory(index);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetailPage(story: story),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStoryPage(onAddStory: addStory),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
