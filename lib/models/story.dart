import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Story class to model the story data
class Story {
  final String title;
  final String content;

  Story({required this.title, required this.content});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}

// SavedStoriesPage widget to display saved stories and handle deletion
class SavedStoriesPage extends StatefulWidget {
  @override
  _SavedStoriesPageState createState() => _SavedStoriesPageState();
}

class _SavedStoriesPageState extends State<SavedStoriesPage> {
  List<Story> savedStories = [];  // List to hold the saved stories

  @override
  void initState() {
    super.initState();
    loadSavedStories();  // Load saved stories when the page is initialized
  }

  // Load saved stories from SharedPreferences
  void loadSavedStories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedStoriesData = prefs.getString('savedStories');
    
    if (savedStoriesData != null) {
      setState(() {
        savedStories = List<Story>.from(
            json.decode(savedStoriesData).map((x) => Story.fromJson(x)));
      });
      print("Loaded saved stories: $savedStories");  // Debug log
    }
  }

  // Delete a saved story
  void deleteSavedStory(int index) async {
    setState(() {
      savedStories.removeAt(index);  // Remove the story from the list
    });

    // Save the updated list to SharedPreferences
    await _saveSavedStories();

    // Optional: If you want to show a message after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Story deleted')),
    );
  }

  // Save the updated saved stories list to SharedPreferences
  Future<void> _saveSavedStories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedStories', json.encode(savedStories));  // Save to SharedPreferences
    print("Saved stories after deletion: ${json.encode(savedStories)}");  // Debug log
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Stories'),
      ),
      body: savedStories.isEmpty
          ? Center(child: Text('No saved stories yet.'))  // Display message if no stories
          : ListView.builder(
              itemCount: savedStories.length,  // Display the list of saved stories
              itemBuilder: (context, index) {
                final story = savedStories[index];  // Get each saved story
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(story.title),  // Display story title
                    subtitle: Text(story.content),  // Display story content
                    trailing: IconButton(
                      icon: Icon(Icons.delete),  // Add delete button
                      onPressed: () => deleteSavedStory(index),  // Delete the story when pressed
                    ),
                  ),
                );
              },
            ),
    );
  }
}
