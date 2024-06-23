import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';

ThemeData appTheme(BuildContext context) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.PRIMARY),
      useMaterial3: true,
      primaryColor: AppColors.PRIMARY,
      primarySwatch: ColorTools.createPrimarySwatch(AppColors.PRIMARY),
      dividerColor: AppColors.SECONDARY,
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.PRIMARY_DARK),
          titleTextStyle:
              TextStyle(fontSize: 22, color: AppColors.PRIMARY_DARK)),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 55.0,
          fontWeight: FontWeight.normal,
          color: AppColors.SECONDARY,
        ),
        displayMedium: TextStyle(
          color: AppColors.BLACK,
          fontSize: 28,
          fontWeight: FontWeight.normal,
        ),
        displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
        ),
        titleLarge: TextStyle(
          fontSize: 33.0,
          fontWeight: FontWeight.normal,
          color: AppColors.PRIMARY,
        ),
        titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
        bodyLarge: TextStyle(fontSize: 22.0, color: AppColors.SECONDARY),
        bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black),
        bodySmall: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.PRIMARY,
          textStyle: const TextStyle(fontSize: 24.0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADUIS),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.PRIMARY,
          textStyle: const TextStyle(fontSize: 24.0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADUIS),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.SECONDARY,
          textStyle: const TextStyle(fontSize: 16.0),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.PRIMARY_DARK,
        foregroundColor: AppColors.WHITE,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.MAIN_SPACE,
            vertical: AppDimens.MAIN_SPACE / 2),
        focusColor: AppColors.SECONDARY,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADUIS)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.BORDER_RADUIS),
          borderSide: const BorderSide(
            color: AppColors.SECONDARY,
          ),
        ),
      ),
    );
