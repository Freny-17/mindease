import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/mood_history_controller.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = MoodHistoryController();
        controller.init();
        return controller;
      },
      child: const _MoodDashboardView(),
    );
  }
}

class _MoodDashboardView extends StatelessWidget {
  const _MoodDashboardView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MoodHistoryController>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final double dynamicGap = size.height * 0.03;

    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final weekMap = controller.weeklyMoodMap;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mood Dashboard",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ✅ Max width constraint for tablets/web
            final double maxWidth = constraints.maxWidth > 800 ? 800 : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: maxWidth,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      /// 1. WEEKLY TRACKER
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: theme.colorScheme.surface,
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_month_rounded, color: theme.colorScheme.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "This Week",
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                final weekdayNumber = index + 1;
                                final mood = weekMap[weekdayNumber];
                                final hasMood = mood != null;

                                return Flexible(
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          weekdays[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: hasMood ? FontWeight.w600 : FontWeight.w400,
                                            color: hasMood
                                                ? theme.colorScheme.onSurface
                                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hasMood
                                              ? theme.colorScheme.primary.withValues(alpha: 0.15)
                                              : theme.colorScheme.surface,
                                          border: hasMood
                                              ? null
                                              : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            mood ?? "-",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: hasMood ? null : Colors.grey.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: dynamicGap),

                      /// 2. MOOD ANALYTICS GRAPH (Text Labels)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: theme.colorScheme.surface,
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Mood Analytics",
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            AspectRatio(
                              aspectRatio: constraints.maxWidth > 600 ? 2.5 : 1.5,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    show: true,
                                    horizontalInterval: 1,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      strokeWidth: 1,
                                      dashArray: [4, 4],
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          final moods = controller.moodFrequency.keys.toList();
                                          if (value.toInt() >= moods.length) return const SizedBox();

                                          final mood = moods[value.toInt()];

                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            space: 8,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                mood, // ✅ Using Text Name instead of Emoji
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  barGroups: controller.moodFrequency.entries
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final value = entry.value.value;

                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: value.toDouble(),
                                          width: constraints.maxWidth > 600 ? 30 : 20,
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              theme.colorScheme.primary,
                                              theme.colorScheme.primary.withValues(alpha: 0.5),
                                            ],
                                          ),
                                          backDrawRodData: BackgroundBarChartRodData(
                                            show: true,
                                            toY: 6,
                                            color: theme.colorScheme.primary.withValues(alpha: 0.05),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: dynamicGap),

                      /// 3. HISTORY TOGGLE
                      GestureDetector(
                        onTap: controller.toggleHistory,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.showHistory ? Icons.keyboard_arrow_up : Icons.history_rounded,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                controller.showHistory ? "Hide History Log" : "View Complete History",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 4. HISTORY LOG
                      if (controller.showHistory)
                        ...controller.moods.map((mood) {
                          final timestamp = mood['timestamp']?.toDate();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: Key(mood['id']),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => controller.deleteMood(mood['id']),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: theme.colorScheme.surface,
                                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.04),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(mood['moodType'], style: const TextStyle(fontSize: 22)),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              timestamp != null
                                                  ? TimeOfDay.fromDateTime(timestamp).format(context)
                                                  : "Unknown time",
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      timestamp != null
                                          ? "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}"
                                          : "",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}