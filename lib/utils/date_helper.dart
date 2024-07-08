import 'package:flutter/material.dart';

class DateHelper {
  static int calculateWorkingDays(DateTime startDate, DateTime endDate) {
    int daysCount = 0;
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      if (currentDate.weekday != DateTime.saturday &&
          currentDate.weekday != DateTime.sunday) {
        daysCount++;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return daysCount;
  }

  static int calculateWorkingDaysForMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError(
          'Invalid month number. Please provide a number between 1 and 12.');
    }

    DateTime startDate = DateTime(DateTime.now().year, month, 1);
    DateTime endDate = DateTime(DateTime.now().year, month + 1, 1)
        .subtract(const Duration(days: 1));

    return calculateWorkingDays(startDate, endDate);
  }

  static DateTimeRange getMonthDateRange(int month) {
    DateTime startDate = DateTime(DateTime.now().year, month, 1);
    DateTime endDate = DateTime(DateTime.now().year, month + 1, 1)
        .subtract(const Duration(days: 1));

    return DateTimeRange(start: startDate, end: endDate);
  }
}
