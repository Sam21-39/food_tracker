import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:food_tracker/core/providers/objectbox_provider.dart';
import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodEntriesAsync = ref.watch(foodEntriesStreamProvider);

    return foodEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: Text('Add some meals to see your statistics!'),
          );
        }

        // Group entries by date for the line chart
        final entriesByDate = _groupEntriesByDate(entries);
        final vegVsNonVegData = _calculateVegVsNonVeg(entries);
        final categoryData = _calculateCategoryDistribution(entries);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Daily Meal Count')
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(
                height: 300,
                child: LineChart(_createLineChartData(entriesByDate))
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, 'Veg vs Non-Veg Distribution')
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 600.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(
                height: 300,
                child: PieChart(_createPieChartData(vegVsNonVegData))
                    .animate()
                    .fadeIn(delay: 900.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, 'Category Distribution')
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 1200.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(
                height: 300,
                child: BarChart(_createBarChartData(categoryData))
                    .animate()
                    .fadeIn(delay: 1500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Map<DateTime, int> _groupEntriesByDate(List<FoodEntry> entries) {
    final Map<DateTime, int> result = {};
    for (var entry in entries) {
      final date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      result[date] = (result[date] ?? 0) + 1;
    }
    return result;
  }

  Map<String, int> _calculateVegVsNonVeg(List<FoodEntry> entries) {
    int vegCount = 0;
    int nonVegCount = 0;
    for (var entry in entries) {
      if (entry.isVegetarian) {
        vegCount++;
      } else {
        nonVegCount++;
      }
    }
    return {'Vegetarian': vegCount, 'Non-Vegetarian': nonVegCount};
  }

  Map<String, int> _calculateCategoryDistribution(List<FoodEntry> entries) {
    final Map<String, int> result = {};
    for (var entry in entries) {
      result[entry.category] = (result[entry.category] ?? 0) + 1;
    }
    return result;
  }

  LineChartData _createLineChartData(Map<DateTime, int> entriesByDate) {
    final spots = entriesByDate.entries
        .map((e) => FlSpot(
              e.key.millisecondsSinceEpoch.toDouble(),
              e.value.toDouble(),
            ))
        .toList();

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(DateFormat('MM/dd').format(date)),
              );
            },
            reservedSize: 30,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: const FlDotData(show: true),
        ),
      ],
    );
  }

  PieChartData _createPieChartData(Map<String, int> data) {
    final total = data.values.fold<int>(0, (sum, count) => sum + count);
    final sections = data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: entry.key == 'Vegetarian' ? Colors.green : Colors.red,
        value: entry.value.toDouble(),
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        radius: 150,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChartData(
      sections: sections,
      sectionsSpace: 2,
      centerSpaceRadius: 0,
    );
  }

  BarChartData _createBarChartData(Map<String, int> data) {
    final groupData = data.entries.toList().asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: Colors.green,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return BarChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value >= data.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  data.keys.elementAt(value.toInt()),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: groupData,
    );
  }
}
