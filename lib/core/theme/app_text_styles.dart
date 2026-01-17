import 'package:flutter/material.dart';
import 'package:i_thera_dashboard/core/theme/app_colors.dart';
import 'package:i_thera_dashboard/core/theme/app_fonts.dart';

import 'font_weight_helper.dart';

class AppTextStyles {
  const AppTextStyles._();
  // heading

  static TextStyle font28Medium = TextStyle(
    fontSize: 28,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.medium,
    color: AppColors.primaryColor,
  );

  static TextStyle font25Bold = TextStyle(
    fontSize: 25,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle font25Medium = TextStyle(
    fontSize: 25,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.medium,
    color: AppColors.white,
  );

  static TextStyle font16Regular = TextStyle(
    fontSize: 16,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.black,
  );

  static TextStyle font14Regular = TextStyle(
    fontSize: 14,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font18Regular = TextStyle(
    fontSize: 18,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font12Regular = TextStyle(
    fontSize: 12,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.textGrey,
  );
  static TextStyle font10Regular = TextStyle(
    fontSize: 10,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.textGrey,
  );
  static TextStyle font20Regular = TextStyle(
    fontSize: 20,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.textGrey,
    height: 1.6,
  );

  static TextStyle font22Regular = TextStyle(
    fontSize: 22,
    fontFamily: AppFonts.alexandria,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.white,
    height: 1.6,
  );
}
