import '../localization/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//* Animated wrapper for SnackBar content: fade + slide up on show.
class _AnimatedSnackBarContent extends StatelessWidget {
  const _AnimatedSnackBarContent({required this.child});

  final Widget child;

  static const Duration _duration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _duration,
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class AppSnackbar {
  AppSnackbar._();

  /// Maximum length for error messages to prevent layout issues
  static const int _maxMessageLength = 150;

  /// Truncate message if too long
  static String _truncateMessage(String message) {
    if (message.length > _maxMessageLength) {
      return '${message.substring(0, _maxMessageLength)}...';
    }
    return message;
  }

  /// Get the bottom padding for SnackBar to account for bottom navigation bar
  /// The main navigation page has a bottom nav bar (~72h) + FAB, so we need
  /// extra margin to prevent the SnackBar from being cut off
  static EdgeInsets _getSnackBarMargin(BuildContext context) {
    // Check if we're in a scaffold with bottom navigation
    final scaffold = Scaffold.maybeOf(context);
    final hasBottomElements = scaffold?.hasFloatingActionButton == true ||
        scaffold?.widget.bottomNavigationBar != null;
    
    // Use larger bottom margin when there's bottom navigation/FAB
    final bottomMargin = hasBottomElements ? 90.h : 16.h;
    
    return EdgeInsets.only(
      left: 16.w,
      right: 16.w,
      top: 16.h,
      bottom: bottomMargin,
    );
  }

  //* success 
  static void showSuccess(BuildContext context, String message, {bool translation = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _AnimatedSnackBarContent(
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  message,
                  translation: translation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: _getSnackBarMargin(context),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }

  //* error
  static void showError(BuildContext context, String message, {bool translation = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Truncate long error messages to prevent layout issues
    final displayMessage = translation ? message : _truncateMessage(message);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _AnimatedSnackBarContent(
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.onErrorContainer,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  displayMessage,
                  translation: translation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: _getSnackBarMargin(context),
        duration: const Duration(seconds: 4),
        elevation: 4,
      ),
    );
  }

  //* info
  static void showInfo(BuildContext context, String message, {bool translation = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _AnimatedSnackBarContent(
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.onSecondaryContainer,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  message,
                  translation: translation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: _getSnackBarMargin(context),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }

  //* warning
  static void showWarning(BuildContext context, String message, {bool translation = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _AnimatedSnackBarContent(
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.onTertiaryContainer,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  message,
                  translation: translation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: colorScheme.tertiaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: _getSnackBarMargin(context),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }
}

