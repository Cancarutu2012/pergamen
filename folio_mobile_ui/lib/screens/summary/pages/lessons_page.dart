// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:folio/api/providers/user_provider.dart';
import 'package:folio/helpers/subject.dart';
import 'package:folio/models/settings.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:folio/utils/format.dart';
import 'package:folio_kreta_api/models/absence.dart';
import 'package:folio_kreta_api/models/lesson.dart';
import 'package:folio_kreta_api/models/subject.dart';
import 'package:folio_kreta_api/models/week.dart';
import 'package:folio_kreta_api/providers/absence_provider.dart';
import 'package:folio_kreta_api/providers/timetable_provider.dart';
import 'package:folio_mobile_ui/common/empty.dart';
import 'package:folio_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectAbsence {
  GradeSubject subject;
  List<Absence> absences;
  double percentage;

  SubjectAbsence(
      {required this.subject, this.absences = const [], this.percentage = 0.0});
}

class LessonsBody extends StatefulWidget {
  const LessonsBody({super.key});

  @override
  LessonsBodyState createState() => LessonsBodyState();
}

class LessonsBodyState extends State<LessonsBody> {
  late UserProvider user;
  late AbsenceProvider absenceProvider;
  late SettingsProvider settingsProvider;
  late TimetableProvider timetableProvider;

  late List<SubjectAbsence> absences = [];
  late List<Widget> lessons = [];
  late List<Absence> delays = [];
  final Map<GradeSubject, Lesson> _lessonCount = {};

  @override
  void initState() {
    super.initState();

    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (final lesson in timetableProvider.getWeek(Week.current()) ?? []) {
        if (!lesson.isEmpty &&
            lesson.subject.id != '' &&
            lesson.lessonYearIndex != null) {
          _lessonCount.update(
            lesson.subject,
            (value) {
              if (lesson.lessonYearIndex! > value.lessonYearIndex!) {
                return lesson;
              } else {
                return value;
              }
            },
            ifAbsent: () => lesson,
          );
        }
      }
      setState(() {});
    });
  }

  void buildSubjectAbsences() {
    Map<GradeSubject, SubjectAbsence> _absences = {};

    for (final absence in absenceProvider.absences) {
      if (absence.delay != 0) continue;

      if (!_absences.containsKey(absence.subject)) {
        _absences[absence.subject] =
            SubjectAbsence(subject: absence.subject, absences: [absence]);
      } else {
        _absences[absence.subject]?.absences.add(absence);
      }
    }

    _absences.forEach((subject, absence) {
      final absentLessonsOfSubject = absenceProvider.absences
          .where((e) => e.subject == subject && e.delay == 0)
          .length;
      final totalLessonsOfSubject = _lessonCount[subject]?.lessonYearIndex ?? 0;

      double absentLessonsOfSubjectPercentage;

      if (absentLessonsOfSubject <= totalLessonsOfSubject) {
        absentLessonsOfSubjectPercentage =
            absentLessonsOfSubject / totalLessonsOfSubject * 100;
      } else {
        absentLessonsOfSubjectPercentage = -1;
      }

      _absences[subject]?.percentage =
          absentLessonsOfSubjectPercentage.clamp(-1, 100.0);
    });

    absences = _absences.values.toList();
    absences.sort((a, b) => -a.percentage.compareTo(b.percentage));
  }

  void getAndSortDelays() {
    delays = absenceProvider.absences;
    delays.sort((a, b) => -a.delay.compareTo(b.delay));
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required bool italic,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = AppColors.of(context).text;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              color: colorScheme.secondary,
              size: 19.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    fontStyle: italic ? FontStyle.italic : null,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void generateTiles() {
    Widget leastAbsent = _statCard(
      icon: SubjectIcon.resolveVariant(
          subject: absences.last.subject, context: context),
      title: absences.last.subject.renamedTo ??
          absences.last.subject.name.capital(),
      italic: absences.last.subject.isRenamed &&
          settingsProvider.renamedSubjectsItalics,
      subtitle: 'absence'.i18n.fill([absences.last.absences.length]),
    );
    if (absences.last.absences.isNotEmpty) {
      lessons.add(leastAbsent);
    } else {
      lessons.add(Empty(subtitle: 'no_lesson'.i18n));
    }

    Widget mostAbsent = _statCard(
      icon: SubjectIcon.resolveVariant(
          subject: absences.first.subject, context: context),
      title: absences.first.subject.renamedTo ??
          absences.first.subject.name.capital(),
      italic: absences.first.subject.isRenamed &&
          settingsProvider.renamedSubjectsItalics,
      subtitle: 'absence'.i18n.fill([absences.first.absences.length]),
    );
    if (absences.first.absences.isNotEmpty) {
      lessons.add(mostAbsent);
    } else {
      lessons.add(Empty(subtitle: 'no_lesson'.i18n));
    }

    Widget mostDelays = _statCard(
      icon: SubjectIcon.resolveVariant(
          subject: delays.first.subject, context: context),
      title:
          delays.first.subject.renamedTo ?? delays.first.subject.name.capital(),
      italic: delays.first.subject.isRenamed &&
          settingsProvider.renamedSubjectsItalics,
      subtitle: 'delay'.i18n.fill([delays.first.delay]),
    );
    if (delays.first.delay != 0) {
      lessons.add(mostDelays);
    } else {
      lessons.add(Empty(subtitle: 'no_lesson'.i18n));
    }
  }

  @override
  Widget build(BuildContext context) {
    buildSubjectAbsences();
    getAndSortDelays();
    generateTiles();

    final headingStyle = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w800,
      color: AppColors.of(context).text,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('title_lessons'.i18n, style: headingStyle),
          const SizedBox(height: 16.0),
          lessons[0],
          const SizedBox(height: 28.0),
          Text('dontfelt'.i18n, style: headingStyle),
          const SizedBox(height: 16.0),
          lessons[1],
          const SizedBox(height: 28.0),
          Text('youlate'.i18n, style: headingStyle),
          const SizedBox(height: 16.0),
          lessons[2],
        ],
      ),
    );
  }
}
