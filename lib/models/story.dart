class Story {
  final String title;
  final String content;

  Story({required this.title, required this.content});

  // Convert Story object to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };

  // Create Story object from JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'],
      content: json['content'],
    );
  }
}
