import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/list_work_session.dart';

class WorkChartWidget extends ConsumerStatefulWidget {
  const WorkChartWidget({super.key, required this.listWorkSession});

  final ListWorkSession listWorkSession;

  final Color barWorkBackgroundColor = AppColors.PRIMARY_LIGHT;
  final Color barBreakBackgroundColor = AppColors.SECONDARY_LIGHT;

  final Color barWorkColor = AppColors.PRIMARY;
  final Color barBreakColor = AppColors.SECONDARY;

  final Color touchedWorkBarColor = AppColors.PRIMARY_DARK;
  final Color touchedBreakBarColor = AppColors.SECONDARY_DARK;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WorkChartWidgetState();
}

class WorkChartWidgetState extends ConsumerState<WorkChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: SizedBox(
          height: 330,
          width: widget.listWorkSession.getUsers().length * 80,
          child: BarChart(
            mainBarData(),
            swapAnimationDuration: animDuration,
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2, {
    bool isTouched = false,
    double width = 16,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y1 + 1 : y1,
          color: isTouched ? widget.touchedWorkBarColor : widget.barWorkColor,
          width: width,
        ),
        BarChartRodData(
          toY: isTouched ? y2 + 1 : y2,
          color: isTouched ? widget.touchedBreakBarColor : widget.barBreakColor,
          width: width,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    var users = widget.listWorkSession.getUsers();
    List<BarChartGroupData> groups = [];

    for (var i = 0; i < users.length; i++) {
      Duration works = widget.listWorkSession.getUserWorkDuration(users[i]);
      Duration breaks = widget.listWorkSession.getUserBreakDuration(users[i]);

      groups.add(makeGroupData(
          i, works.inSeconds.toDouble(), breaks.inSeconds.toDouble(),
          isTouched: i == touchedIndex));
    }

    return groups;
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -150,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            var users = widget.listWorkSession.getUsers();
            var user = users[group.x];

            return BarTooltipItem(
              '${user.fullName}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      "Work ${widget.listWorkSession.getUserWorkDuration(user).toString().split(".")[0]}\nBreak ${widget.listWorkSession.getUserBreakDuration(user).toString().split(".")[0]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        "${value.toInt() + 1}",
        style: const TextStyle(
          color: AppColors.PRIMARY_DARK,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
