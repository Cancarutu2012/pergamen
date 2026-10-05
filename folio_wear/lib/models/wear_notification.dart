class WearNotification {
  final String id;
  final String title;
  final String body;
  final String type; // "grade" | "absence" | "message" | "note" | "exam" | "homework"
  final int? gradeValue; // 1-5; null for non-grade types
  final DateTime timestamp;

  const WearNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.gradeValue,
    required this.timestamp,
  });

  factory WearNotification.fromJson(Map<String, dynamic> json) {
    return WearNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      gradeValue: json['gradeValue'] as int?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'gradeValue': gradeValue,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}
