import 'dart:math';

import 'package:folio/api/providers/user_provider.dart';
import 'package:folio/helpers/average_helper.dart';
import 'package:folio/models/settings.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:folio/ui/widgets/grade/grade_tile.dart';
import 'package:folio/utils/format.dart';
import 'package:folio_kreta_api/models/grade.dart';
import 'package:folio_kreta_api/models/subject.dart';
import 'package:folio_kreta_api/providers/grade_provider.dart';
import 'package:folio_mobile_ui/common/empty.dart';
import 'package:folio_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradesBody extends StatefulWidget {
  const GradesBody({super.key});

  @override
  GradesBodyState createState() => GradesBodyState();
}

class GradesBodyState extends State<GradesBody> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late SettingsProvider settings;

  late double subjectAvg;
  late double endYearAvg;

  List<Widget> bestTiles = [];
  List<Widget> worstTiles = [];

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
    settings = Provider.of<SettingsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  Widget _subjectTile(GradeSubject subject, double avg, int index) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300 + (index * 120)),
      transform: Matrix4.translationValues(
          animation ? 0 : MediaQuery.of(context).size.width, 0, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Row(
          children: [
            GradeValueWidget(
              GradeValue(avg.round(), '', '', 100),
              fill: true,
              size: 27.5,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                subject.renamedTo ?? subject.name.capital(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  color: AppColors.of(context).text,
                  fontStyle:
                      settings.renamedSubjectsItalics && subject.isRenamed
                          ? FontStyle.italic
                          : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getGrades() {
    List<GradeSubject> subjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList();

    Map<GradeSubject, double> subjectAvgs = {};
    for (final subject in subjects) {
      final avg = AverageHelper.averageEvals(getSubjectGrades(subject));
      if (avg != 0) subjectAvgs[subject] = avg;
    }

    subjectAvg = subjectAvgs.isNotEmpty
        ? subjectAvgs.values.fold(0.0, (double a, double b) => a + b) /
            subjectAvgs.length
        : 0.0;

    List<Grade> endYearGrades = gradeProvider.grades
        .where((grade) => grade.type == GradeType.endYear)
        .toList();
    endYearAvg = endYearGrades.isNotEmpty
        ? AverageHelper.averageEvals(endYearGrades, finalAvg: true)
        : subjectAvg;

    final ranked = subjectAvgs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final splitCount = min(3, ranked.length ~/ 2);

    bestTiles = [
      for (var i = 0; i < splitCount; i++)
        _subjectTile(ranked[i].key, ranked[i].value, i + 1),
    ];

    final worstEntries =
        ranked.sublist(ranked.length - splitCount).reversed.toList();
    worstTiles = [
      for (var i = 0; i < worstEntries.length; i++)
        _subjectTile(worstEntries[i].key, worstEntries[i].value, i + 1),
    ];

    if (bestTiles.isEmpty) bestTiles.add(Empty(subtitle: 'no_grades'.i18n));
    if (worstTiles.isEmpty) worstTiles.add(Empty(subtitle: 'no_grades'.i18n));
  }

  Widget _tileList(List<Widget> tiles) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: max(tiles.length, 1),
        itemBuilder: (context, index) {
          if (tiles.isEmpty) return Container();
          if (tiles[index].runtimeType == AnimatedContainer) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRect(child: tiles[index]),
            );
          }
          return tiles[index];
        },
      );

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);

    getGrades();

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
          Text('title_grades'.i18n, style: headingStyle),
          const SizedBox(height: 16.0),
          Center(
            child: GradeValueWidget(
              GradeValue(endYearAvg.round(), '', '', 100),
              fill: true,
              size: 56.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Text('best_subjects'.i18n, style: headingStyle),
          const SizedBox(height: 10.0),
          Expanded(child: _tileList(bestTiles)),
          const SizedBox(height: 16.0),
          Text('to_improve'.i18n, style: headingStyle),
          const SizedBox(height: 10.0),
          Expanded(child: _tileList(worstTiles)),
        ],
      ),
    );
  }
}
