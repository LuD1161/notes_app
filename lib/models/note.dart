class Note {
  int id;
  String date;
  String title;
  int priority;
  String description;

  Note({
    this.id,
    this.date,
    this.title,
    this.priority,
    this.description,
  });

  // Convert a Note object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = date;

    return map;
  }

  // Extract a Note object from a Map Object
  factory Note.fromMap(Map<String, dynamic> doc) {
    return Note(
      id: doc['id'] ?? -1,
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      priority: doc['priority'] ?? 0,
      date: doc['date'] ?? DateTime.now(),
    );
  }
}
