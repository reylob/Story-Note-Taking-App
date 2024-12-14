import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(StoryApp());
}

class StoryApp extends StatelessWidget {
  StoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NavigationWrapper(),
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    AboutPage(), // New About Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About', // About Tab
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Story> stories = [];
  List<Story> savedStories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storiesData = prefs.getString('stories');
    final String? savedStoriesData = prefs.getString('savedStories');

    setState(() {
      if (storiesData != null) {
        stories = List<Story>.from(
            json.decode(storiesData).map((x) => Story.fromJson(x)));
      }
      if (savedStoriesData != null) {
        savedStories = List<Story>.from(
            json.decode(savedStoriesData).map((x) => Story.fromJson(x)));
      }
    });
  }

  Future<void> _saveStories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('stories', json.encode(stories));
    prefs.setString('savedStories', json.encode(savedStories));
  }

  void addNewStory(String title, String content) {
    setState(() {
      stories.add(Story(title: title, content: content));
      _saveStories();
    });
  }

  void toggleSavedStory(Story story) {
    setState(() {
      if (savedStories.contains(story)) {
        savedStories.remove(story);
      } else {
        savedStories.add(story);
      }
      _saveStories();
    });
  }

  void deleteStory(int index) {
    setState(() {
      stories.removeAt(index);
      _saveStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SavedStoriesPage(savedStories: savedStories),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(story.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: savedStories.contains(story)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () => toggleSavedStory(story),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteStory(index),
                  ),
                ],
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
          showDialog(
            context: context,
            builder: (context) => AddStoryDialog(onAdd: addNewStory),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About StoryNoteApp',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Description with background color and rounded corners
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A simple story app where you can add, view, save, and delete stories. Developed by Edreynald F. Alob.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Version: 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Button to show more info or contact info
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action for the button, e.g., opening a contact page or more info.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .blueAccent, // Changed `primary` to `backgroundColor`
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    'Contact Me',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'History of stories will be displayed here.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class AddStoryDialog extends StatefulWidget {
  final Function(String, String) onAdd;

  AddStoryDialog({required this.onAdd});

  @override
  _AddStoryDialogState createState() => _AddStoryDialogState();
}

class _AddStoryDialogState extends State<AddStoryDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 16.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Solid color background
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Story',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Story Title',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Story Content',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 5,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isNotEmpty && content.isNotEmpty) {
                      widget.onAdd(title, content);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
            
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

class SavedStoriesPage extends StatefulWidget {
  final List<Story> savedStories;

  SavedStoriesPage({required this.savedStories});

  @override
  _SavedStoriesPageState createState() => _SavedStoriesPageState();
}

class _SavedStoriesPageState extends State<SavedStoriesPage> {
  late List<Story> savedStories;

  @override
  void initState() {
    super.initState();
    savedStories =
        widget.savedStories; // Initialize savedStories with the passed data
  }

  // A method to load saved stories (simulate loading from storage)
  void loadSavedStories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedStoriesData = prefs.getString('savedStories');

    if (savedStoriesData != null) {
      print("Loaded stories: $savedStoriesData");
      setState(() {
        savedStories = List<Story>.from(
            json.decode(savedStoriesData).map((x) => Story.fromJson(x)));
      });
    }
  }

  // A method to delete a story
  void deleteStory(int index) async {
    setState(() {
      savedStories.removeAt(index); // Remove the story from the list
    });

    // Save the updated list after deletion
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedStories',
        json.encode(savedStories.map((e) => e.toJson()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Stories'),
      ),
      body: ListView.builder(
        itemCount: savedStories.length,
        itemBuilder: (context, index) {
          final story = savedStories[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(story.title),
              subtitle: Text(story.content),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    deleteStory(index), // Delete the story when pressed
              ),
            ),
          );
        },
      ),
    );
  }
}

class Story {
  final String title;
  final String content;

  Story({required this.title, required this.content});

  // Convert a map to a Story instance
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  // Convert a Story instance to a map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
