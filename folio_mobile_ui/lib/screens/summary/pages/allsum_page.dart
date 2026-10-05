import 'package:folio/api/providers/user_provider.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:folio_kreta_api/models/absence.dart';
import 'package:folio_kreta_api/models/grade.dart';
import 'package:folio_kreta_api/models/subject.dart';
import 'package:folio_kreta_api/providers/absence_provider.dart';
import 'package:folio_kreta_api/providers/grade_provider.dart';
import 'package:folio_kreta_api/providers/homework_provider.dart';
import 'package:folio_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSumBody extends StatefulWidget {
  const AllSumBody({super.key});

  @override
  AllSumBodyState createState() => AllSumBodyState();
}

class AllSumBodyState extends State<AllSumBody> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late HomeworkProvider homeworkProvider;
  late AbsenceProvider absenceProvider;
  //late TimetableProvider timetableProvider;

  late Map<String, Map<String, dynamic>> things = {};
  late List<Widget> firstSixTiles = [];
  late List<Widget> lastSixTiles = [];

  int avgDropValue = 0;
  bool animation = false;

  List<Grade> getSubjectGrades(GradeSubject subject, {int days = 0}) =>
      gradeProvider.grades
          .where((e) =>
              e.subject == subject &&
              e.type == GradeType.midYear &&
              (days == 0 ||
                  e.date
                      .isBefore(DateTime.now().subtract(Duration(days: days)))))
          .toList();

  @override
  void initState() {
    super.initState();

    gradeProvider = Provider.of<GradeProvider>(context, listen: false);
    homeworkProvider = Provider.of<HomeworkProvider>(context, listen: false);
    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    //timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  void getGrades() {
    var allGrades = gradeProvider.grades;
    var testsGrades = gradeProvider.grades.where((a) => a.value.weight == 100);
    var closingTestsGrades =
        gradeProvider.grades.where((a) => a.value.weight >= 200);

    things.addAll({
      'tests': {'name': 'test'.i18n, 'value': testsGrades.length},
      'closingTests': {
        'name': 'closingtest'.i18n,
        'value': closingTestsGrades.length
      },
      'grades': {'name': 'grade'.i18n, 'value': allGrades.length}
    });
  }

  void getHomework() {
    var allHomework = homeworkProvider.homework;

    things.addAll({
      'homework': {'name': 'hw'.i18n, 'value': allHomework.length}
    });
  }

  void getSubjects() {
    var allSubjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    //var totalLessons;
    var totalLessons = 0;

    things.addAll({
      'subjects': {'name': 'subject'.i18n, 'value': allSubjects.length},
      'lessons': {'name': 'lesson'.i18n, 'value': totalLessons}
    });
  }

  void getAbsences() {
    var allAbsences = absenceProvider.absences.where((a) => a.delay == 0);
    var excusedAbsences = absenceProvider.absences
        .where((a) => a.state == Justification.excused && a.delay == 0);
    var unexcusedAbsences = absenceProvider.absences.where((a) =>
        (a.state == Justification.unexcused ||
            a.state == Justification.pending) &&
        a.delay == 0);

    things.addAll({
      'absences': {'name': 'absence_sum'.i18n, 'value': allAbsences.length},
      'excusedAbsences': {
        'name': 'excused'.i18n,
        'value': excusedAbsences.length
      },
      'unexcusedAbsences': {
        'name': 'unexcused'.i18n,
        'value': unexcusedAbsences.length
      }
    });
  }

  void getDelays() {
    var allDelays = absenceProvider.absences.where((a) => a.delay > 0);
    var delayTimeList = (allDelays.map((a) {
      return a.delay;
    }).toList());
    var totalDelayTime = 0;
    if (delayTimeList.isNotEmpty) {
      totalDelayTime = delayTimeList.reduce((a, b) => a + b);
    }
    var unexcusedDelays = absenceProvider.absences
        .where((a) => a.state == Justification.unexcused && a.delay > 0);

    things.addAll({
      'delays': {'name': 'delay_sum'.i18n, 'value': allDelays.length},
      'totalDelay': {'name': 'min'.i18n, 'value': totalDelayTime},
      'unexcusedDelays': {
        'name': 'unexcused'.i18n,
        'value': unexcusedDelays.length
      }
    });
  }

  void getEverything() {
    getGrades();
    getHomework();
    getSubjects();
    getAbsences();
    getDelays();
  }

  void generateTiles() {
    final colorScheme = Theme.of(context).colorScheme;
    final colorPairs = [
      (colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
      (colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
      (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
    ];

    var index = 0;
    for (var i in things.values) {
      final (bg, fg) = colorPairs[index % colorPairs.length];

      Widget w = Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i.values.toList()[1].toString(),
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28.0,
                color: fg,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              i.values.toList()[0],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: fg.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      );

      // TO-DO: az orakat es a hazikat szarul keri le, de majd meg lesz csinalva
      if (firstSixTiles.length < 6) {
        firstSixTiles.add(w);
      } else if (lastSixTiles.length < 6) {
        lastSixTiles.add(w);
      } else {
        break;
      }
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    getEverything();
    generateTiles();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
      children: [
        Text(
          'title_allsum'.i18n,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            color: AppColors.of(context).text,
          ),
        ),
        const SizedBox(height: 16.0),
        ClipRect(
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 420),
            transform: Matrix4.translationValues(
                animation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            height: 250,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: firstSixTiles,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        ClipRect(
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 420),
            transform: Matrix4.translationValues(
                animation ? 0 : -MediaQuery.of(context).size.width, 0, 0),
            height: 250,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: lastSixTiles,
            ),
          ),
        ),
      ],
    );
  }
}
