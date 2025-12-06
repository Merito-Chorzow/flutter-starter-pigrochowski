class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  // na później pod lokalizację
  final double? lat;
  final double? lng;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.lat,
    this.lng,
  });

  factory JournalEntry.fromApi(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'].toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['body'] ?? '').toString(),
      date: DateTime.now(),
    );
  }
}
