class LocalNotification {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime receivedAt;
  final Map<String, dynamic> data;

  LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.receivedAt,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'receivedAt': receivedAt.toIso8601String(),
      'data': data,
    };
  }

  factory LocalNotification.fromMap(Map<String, dynamic> map) {
    return LocalNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      category: map['category'],
      receivedAt: DateTime.parse(map['receivedAt']),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
    );
  }
}
