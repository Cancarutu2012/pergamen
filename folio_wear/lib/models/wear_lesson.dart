class WearLesson {
  final String id;
  final String subject;
  final String room;
  final String teacher;
  final DateTime start;
  final DateTime end;
  final int lessonIndex;
  final String status; // "normal" | "cancelled" | "substitution"
  final bool online;
  final bool hasHomework;
  final bool hasExam;

  const WearLesson({
    required this.id,
    required this.subject,
    required this.room,
    required this.teacher,
    required this.start,
    required this.end,
    required this.lessonIndex,
    required this.status,
    required this.online,
    this.hasHomework = false,
    this.hasExam = false,
  });

  factory WearLesson.fromJson(Map<String, dynamic> json) {
    return WearLesson(
      id: json['id'] as String,
      subject: json['subject'] as String,
      room: json['room'] as String,
      teacher: json['teacher'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(json['start'] as int),
      end: DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
      lessonIndex: json['lessonIndex'] as int,
      status: json['status'] as String,
      online: json['online'] as bool,
      hasHomework: (json['hasHomework'] as bool?) ?? false,
      hasExam: (json['hasExam'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'room': room,
        'teacher': teacher,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'lessonIndex': lessonIndex,
        'status': status,
        'online': online,
        'hasHomework': hasHomework,
        'hasExam': hasExam,
      };

  bool get isCancelled => status == 'cancelled';
  bool get isSubstitution => status == 'substitution';

  bool isActiveAt(DateTime time) => time.isAfter(start) && time.isBefore(end);
}
