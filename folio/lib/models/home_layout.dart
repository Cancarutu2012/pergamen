import 'dart:convert';
import 'dart:developer';

enum HomeWidgetType {
  greeting,
  liveCard,
  gradeAverage,
  recentGrades,
  subjectAverages,
  upcomingExam,
  examList,
  unreadMessages,
  recentMessages,
  absenceCount,
  recentAbsences,
  timetableToday,
  nextLesson,
  homeworkList,
  notesList,
  attendanceRate,
  examCountdown,
  weeklySchedule,
  gradeChart,
  quickStats,
}

enum HomeWidgetSize { half, full }

class HomeWidgetItem {
  HomeWidgetType type;
  HomeWidgetSize size;
  bool enabled;

  HomeWidgetItem({
    required this.type,
    required this.size,
    required this.enabled,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'size': size.name,
        'enabled': enabled,
      };

  factory HomeWidgetItem.fromMap(Map<String, dynamic> map) {
    return HomeWidgetItem(
      type: HomeWidgetType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => HomeWidgetType.greeting,
      ),
      size: HomeWidgetSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => HomeWidgetSize.full,
      ),
      enabled: map['enabled'] as bool? ?? false,
    );
  }
}

class HomeLayout {
  List<HomeWidgetItem> items;

  HomeLayout({required this.items});

  static HomeLayout defaults() {
    return HomeLayout(items: [
      HomeWidgetItem(type: HomeWidgetType.greeting, size: HomeWidgetSize.full, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.liveCard, size: HomeWidgetSize.full, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.gradeAverage, size: HomeWidgetSize.half, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.nextLesson, size: HomeWidgetSize.half, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.recentGrades, size: HomeWidgetSize.full, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.timetableToday, size: HomeWidgetSize.full, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.upcomingExam, size: HomeWidgetSize.half, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.absenceCount, size: HomeWidgetSize.half, enabled: true),
      HomeWidgetItem(type: HomeWidgetType.unreadMessages, size: HomeWidgetSize.half, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.attendanceRate, size: HomeWidgetSize.half, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.examCountdown, size: HomeWidgetSize.half, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.recentMessages, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.recentAbsences, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.examList, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.homeworkList, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.notesList, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.subjectAverages, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.weeklySchedule, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.gradeChart, size: HomeWidgetSize.full, enabled: false),
      HomeWidgetItem(type: HomeWidgetType.quickStats, size: HomeWidgetSize.full, enabled: false),
    ]);
  }

  factory HomeLayout.fromJson(String json) {
    if (json.isEmpty) return HomeLayout.defaults();
    try {
      final List<dynamic> list = jsonDecode(json) as List<dynamic>;
      final items = list
          .map((e) => HomeWidgetItem.fromMap(e as Map<String, dynamic>))
          .toList();
      // Ensure all widget types are present (new types added in updates)
      final presentTypes = items.map((e) => e.type).toSet();
      final defaults = HomeLayout.defaults();
      for (final def in defaults.items) {
        if (!presentTypes.contains(def.type)) {
          items.add(def);
        }
      }
      return HomeLayout(items: items);
    } catch (e) {
      log('[HomeLayout] fromJson error: $e');
      return HomeLayout.defaults();
    }
  }

  String toJson() {
    return jsonEncode(items.map((e) => e.toMap()).toList());
  }
}
