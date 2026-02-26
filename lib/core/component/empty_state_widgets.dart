import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

//* Empty state for "no search results" — uses faill-search icon. Message translated via [messageKey].

class EmptySearchResultWidget extends StatelessWidget {
  const EmptySearchResultWidget({
    super.key,
    this.messageKey,
    this.namedArgs,
    this.iconSize,
  });

  /// Locale key (e.g. [LocaleKeys.home_noSearchResults] or [LocaleKeys.home_noResultsFor]).
  final String? messageKey;
  /// For parameterized keys (e.g. noResultsFor: {"query": "shirt"}).
  final Map<String, String>? namedArgs;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final size = iconSize ?? 120.r;
    final key = messageKey ?? LocaleKeys.home_noSearchResults;
    final text = namedArgs != null && namedArgs!.isNotEmpty
        ? key.tr(namedArgs: namedArgs!)
        : key.tr();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.icons.faillSearch.path,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(
                appColors?.primaryNavy ?? colorScheme.outline,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            AppText(
              text,
              translation: false,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: appColors?.primaryNavy ?? colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//* Empty state for home content (no products / empty data) — uses bucket_empty icon. Message translated via [messageKey].

class EmptyHomeContentWidget extends StatelessWidget {
  const EmptyHomeContentWidget({
    super.key,
    this.messageKey,
    this.iconSize,
  });

  /// Locale key (e.g. [LocaleKeys.home_noProductsFound]).
  final String? messageKey;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final size = iconSize ?? 120.r;
    final text = (messageKey ?? LocaleKeys.home_noProductsFound).tr();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.icons.bucketEmpty.path,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(
                appColors?.primaryNavy ?? colorScheme.outline,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            AppText(
              text,
              translation: false,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: appColors?.primaryNavy ?? colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
