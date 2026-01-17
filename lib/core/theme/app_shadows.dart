import 'package:flutter/material.dart';
import 'package:i_thera_dashboard/core/theme/app_colors.dart';

class AppShadows {
  const AppShadows._();

  static BoxShadow shadow1 = const BoxShadow(
    color: AppColors.grey100,
    spreadRadius: 1,
    blurRadius: 1,
    offset: Offset(0, 1),
  );
}
