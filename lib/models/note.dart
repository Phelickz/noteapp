class Note {
    final int id;
    final String title;
    final String content;

    Note({this.id, this.title, this.content});

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'title': title,
        'content': content,
      };
    }

    factory Note.fromMap(Map<String, dynamic> json) => new Note(
      id: json['id'],
      title: json['title'],
      content: json['content']
    );


    // Implement toString to make it easier to see information about
    // each dog when using the print statement.
    @override
    String toString() {
      return 'Note{id: $id, title: $title, content: $content}';
    }
}