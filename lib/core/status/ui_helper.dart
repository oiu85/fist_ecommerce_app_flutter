import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import 'bloc_status.dart';

/// Enum to identify different error types
enum ErrorType {
  noInternet,
  timeout,
  notFound,
  generic,
}

/// Helper class to convert raw error messages to user-friendly UI messages
class ErrorMessageHelper {
  /// Converts raw error message to friendly UI message
  /// Logs the original error to terminal for debugging
  /// Returns a user-friendly message for UI display
  static String getFriendlyErrorMessage(String? rawError) {
    // Log original error to terminal for debugging
    if (rawError != null && rawError.isNotEmpty) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('⚠️  ORIGINAL ERROR (Terminal Log):');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint(rawError);
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    if (rawError == null || rawError.isEmpty) {
      return LocaleKeys.status_somethingWentWrong;
    }

    final lowerError = rawError.toLowerCase().trim();

    // Handle HTTP status codes
    if (lowerError.contains('server error:')) {
      // Extract status code if present
      final statusCodeMatch = RegExp(r'(\d{3})').firstMatch(rawError);
      if (statusCodeMatch != null) {
        final statusCode = int.tryParse(statusCodeMatch.group(1) ?? '');
        switch (statusCode) {
          case 400:
            return LocaleKeys.errors_badRequest;
          case 401:
            return LocaleKeys.errors_unauthorized;
          case 403:
            return LocaleKeys.errors_accessDenied;
          case 404:
            return LocaleKeys.errors_notFound;
          case 405:
            return LocaleKeys.errors_actionNotAllowed;
          case 408:
            return LocaleKeys.errors_requestTimeout;
          case 409:
            return LocaleKeys.errors_conflict;
          case 422:
            return LocaleKeys.errors_invalidData;
          case 429:
            return LocaleKeys.errors_tooManyRequests;
          case 500:
            return LocaleKeys.errors_internalServerError;
          case 502:
            return LocaleKeys.errors_badGateway;
          case 503:
            return LocaleKeys.errors_serviceUnavailable;
          case 504:
            return LocaleKeys.errors_gatewayTimeout;
          default:
            if (statusCode != null && statusCode >= 400 && statusCode < 500) {
              return LocaleKeys.errors_clientError;
            } else if (statusCode != null && statusCode >= 500) {
              return LocaleKeys.errors_serverError;
            }
        }
      }
    }

    // Handle network/connection errors
    if (lowerError.contains('no internet') ||
        lowerError.contains('no internet connection') ||
        lowerError.contains('network unreachable') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup') ||
        lowerError.contains('connection refused') ||
        lowerError.contains('network is unreachable')) {
      return LocaleKeys.errors_noInternetConnection;
    }

    // Handle timeout errors
    if (lowerError.contains('timeout') ||
        lowerError.contains('connection timeout') ||
        lowerError.contains('timed out') ||
        lowerError.contains('deadline exceeded') ||
        lowerError.contains('send timeout') ||
        lowerError.contains('receive timeout') ||
        lowerError.contains('connection timeout')) {
      return LocaleKeys.errors_connectionTimeout;
    }

    // Handle parsing errors
    if (lowerError.contains('failed to parse') ||
        lowerError.contains('invalid response format') ||
        lowerError.contains('json') && lowerError.contains('error')) {
      return LocaleKeys.errors_processingResponse;
    }

    // Handle authentication errors
    if (lowerError.contains('unauthorized') ||
        lowerError.contains('authentication failed') ||
        lowerError.contains('invalid token') ||
        lowerError.contains('token expired')) {
      return LocaleKeys.errors_sessionExpired;
    }

    // Handle validation errors from server
    if (lowerError.contains('validation') || lowerError.contains('invalid')) {
      // Try to extract a cleaner message from validation errors
      // Check if the error contains user-friendly message after "message:" or ":"
      final colonIndex = rawError.indexOf(':');
      if (colonIndex != -1 && colonIndex < rawError.length - 1) {
        final extractedMessage = rawError.substring(colonIndex + 1).trim();
        // Only use extracted message if it's reasonable length and doesn't look like raw error
        if (extractedMessage.length < 200 &&
            !extractedMessage.contains('server error') &&
            !extractedMessage.contains('statuscode')) {
          return extractedMessage;
        }
      }
      return LocaleKeys.errors_invalidInput;
    }

    // Handle generic server errors
    if (lowerError.contains('server error') ||
        lowerError.contains('internal error')) {
      return LocaleKeys.errors_serverError;
    }

    // Handle "not found" errors
    if (lowerError.contains('404') ||
        (lowerError.contains('not found') && !lowerError.contains('page'))) {
      return LocaleKeys.errors_notFound;
    }

    // For any other errors, check if the message is already user-friendly
    // If it's too technical or contains technical terms, use generic message
    final technicalTerms = [
      'exception',
      'error:',
      'failed:',
      'unexpected error',
      'dioexception',
      'networkfailure',
      'stacktrace',
      'at ',
      'null',
    ];

    final containsTechnicalTerms =
    technicalTerms.any((term) => lowerError.contains(term));

    if (containsTechnicalTerms) {
      return LocaleKeys.status_somethingWentWrong;
    }

    // If the error message is relatively short and doesn't contain technical terms,
    // it might already be user-friendly, so return it as is (but still log original)
    if (rawError.length < 150 &&
        !rawError.contains('Server error:') &&
        !rawError.contains('Network Error:')) {
      return rawError;
    }

    // Default to generic error message
    return LocaleKeys.status_somethingWentWrong;
  }
}

/// Helper class to determine error type from error message
class ErrorTypeHelper {
  /// Detects error type from error message
  static ErrorType detectErrorType(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return ErrorType.generic;
    }

    final lowerError = errorMessage.toLowerCase();

    // Check for no internet connection (priority: check first)
    if (lowerError.contains('no internet') ||
        lowerError.contains('no internet connection') ||
        lowerError.contains('connection error') ||
        lowerError.contains('network unreachable') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup') ||
        lowerError.contains('connection refused')) {
      return ErrorType.noInternet;
    }

    // Check for timeout (priority: check second)
    if (lowerError.contains('timeout') ||
        lowerError.contains('connection timeout') ||
        lowerError.contains('timed out') ||
        lowerError.contains('deadline exceeded') ||
        lowerError.contains('send timeout') ||
        lowerError.contains('receive timeout')) {
      return ErrorType.timeout;
    }

    // Check for not found (404) (priority: check third)
    if (lowerError.contains('404') ||
        lowerError.contains('not found') ||
        lowerError.contains('server error: 404') ||
        (lowerError.contains('server error') && lowerError.contains('404'))) {
      return ErrorType.notFound;
    }

    return ErrorType.generic;
  }

  /// Gets the status image path based on error type
  static String getStatusImagePath(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.noInternet:
        return 'assets/images/status/offline_faliure.png';
      case ErrorType.timeout:
        return 'assets/images/status/offline_faliure.png';
      case ErrorType.notFound:
        return 'assets/images/status/not_found_404.png';
      case ErrorType.generic:
        return 'assets/images/status/no_result.png';
    }
  }
}

class UiHelperStatus extends StatefulWidget {
  final BlocStatus state;
  final String? message;
  final double? size;
  final bool showDefaultMessage;
  final VoidCallback? onRetry;

  const UiHelperStatus({
    super.key,
    required this.state,
    this.message,
    this.size,
    this.showDefaultMessage = true,
    this.onRetry,
  });

  @override
  State<UiHelperStatus> createState() => _UiHelperStatusState();
}

class _UiHelperStatusState extends State<UiHelperStatus> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.isInitial() || widget.state.isSuccess()) {
      return const SizedBox.shrink();
    }

    final animationSize = widget.size ?? 200.w;
    final isLoading = widget.state.isLoading() || widget.state.isLoadingMore();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Show loading indicator or error animation
            if (isLoading)
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              )
            else
              _buildErrorAnimation(animationSize),
            SizedBox(height: 24.h),
            if (widget.showDefaultMessage || widget.message != null)
              AppText(
                widget.message ??
                    (isLoading
                        ? LocaleKeys.status_loading
                        : ErrorMessageHelper.getFriendlyErrorMessage(
                        widget.state.error)),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            if (widget.state.isFail() && widget.onRetry != null) ...[
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: Icon(Icons.refresh, size: 20.sp),
                label: AppText(
                  LocaleKeys.status_tryAgain,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the appropriate error animation based on error type
  Widget _buildErrorAnimation(double size) {
    // Use original error for error type detection (before friendly conversion)
    final errorType = ErrorTypeHelper.detectErrorType(widget.state.error);
    final imagePath = ErrorTypeHelper.getStatusImagePath(errorType);

    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}


/// Simple Skeleton Loader
/// Usage: SimpleSkeleton(isLoading: true, child: YourWidget())
class SimpleSkeleton extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool ignoreContainers;

  const SimpleSkeleton({
    super.key,
    required this.isLoading,
    required this.child,
    this.ignoreContainers = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: ignoreContainers,
      effect: ShimmerEffect(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[50]!,
        duration: const Duration(seconds: 1),
      ),
      textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.5),
      justifyMultiLineText: false,
      child: child,
    );
  }
}

/// Simple Skeleton with BlocStatus
/// Usage: SimpleSkeletonStatus(state: blocStatus, child: YourWidget())
class SimpleSkeletonStatus extends StatelessWidget {
  final BlocStatus state;
  final Widget child;

  const SimpleSkeletonStatus({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Show skeleton when loading, loading more, OR initial (first run before data loads)
    return SimpleSkeleton(
      isLoading:
      state.isLoading() || state.isLoadingMore() || state.isInitial(),
      child: child,
    );
  }
}


class NoDataWidget extends StatelessWidget {
  final String? message;
  final double? imageWidth;
  final double? imageHeight;

  const NoDataWidget({
    super.key,
    this.message,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagePath = Assets.lottie.notFound;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageWidth ?? 250.w,
              height: imageHeight ?? 250.h,
              fit: BoxFit.contain,
            ),
            if (message != null) ...[
              AppText(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// SVG Image with Skeleton Support
class SkeletonSvgImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SkeletonSvgImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = Skeletonizer.maybeOf(context)?.enabled ?? false;

    if (isLoading) {
      return Skeleton.replace(
        width: width ?? 24,
        height: height ?? 24,
        child: SvgPicture.asset(
          path,
          width: width,
          height: height,
          colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          fit: fit,
        ),
      );
    }

    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter:
      color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit,
    );
  }
}
