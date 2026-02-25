import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color_extension.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({
    super.key,
    required this.isEnabled,
    this.onChanged,
    this.width = 44,
    this.height = 24,
  });

  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>()!;

    return GestureDetector(
      onTap: onChanged != null ? () {
        debugPrint('CustomToggleButton tapped, current state: $isEnabled, new state: ${!isEnabled}');
        onChanged!(!isEnabled);
      } : null, // Set onTap to null when onChanged is null
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height.h / 2),
          color: isEnabled ? colorScheme.primary : appColors.borderColor,
        ),
        child: Align(
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Container(
              width: (height - 4).w,
              height: (height - 4).h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
