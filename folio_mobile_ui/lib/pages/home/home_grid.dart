import 'package:flutter/material.dart';
import 'package:folio/models/home_layout.dart';
import 'package:folio/models/settings.dart';
import 'package:provider/provider.dart';

import 'home_widgets.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key});

  /// Groups enabled items into rows:
  /// - full-size items get their own row
  /// - consecutive half-size items are paired into rows of 2
  /// - a lone trailing half-size item gets its own row
  List<List<HomeWidgetItem>> _buildRows(List<HomeWidgetItem> items) {
    final rows = <List<HomeWidgetItem>>[];
    int i = 0;
    while (i < items.length) {
      final item = items[i];
      if (item.size == HomeWidgetSize.full) {
        rows.add([item]);
        i++;
      } else {
        // half
        if (i + 1 < items.length && items[i + 1].size == HomeWidgetSize.half) {
          rows.add([item, items[i + 1]]);
          i += 2;
        } else {
          rows.add([item]);
          i++;
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final layout = settings.homeLayout;
    final enabled = layout.items.where((w) => w.enabled).toList();
    final rows = _buildRows(enabled);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: 10),
            _buildRow(rows[r]),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRow(List<HomeWidgetItem> items) {
    if (items.length == 1) {
      final item = items.first;
      if (item.size == HomeWidgetSize.half) {
        // lone half: take half width
        return Row(
          children: [
            Expanded(child: buildHomeWidget(item.type)),
            const Expanded(child: SizedBox()),
          ],
        );
      }
      return buildHomeWidget(item.type);
    }
    // pair of halves
    return Row(
      children: [
        Expanded(child: buildHomeWidget(items[0].type)),
        const SizedBox(width: 10),
        Expanded(child: buildHomeWidget(items[1].type)),
      ],
    );
  }
}
