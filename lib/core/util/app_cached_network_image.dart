import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'url_helper.dart';

/// App-level cached network image widget with safe SVG support.
///
/// Handles both raster images (via [CachedNetworkImage]) and SVG images
/// (via safe pre-validated [SvgPicture.string]). SVG icons from the API
/// are downloaded, validated by attempting compilation with
/// [SvgStringLoader.loadBytes], and cached in memory before rendering
/// to prevent unhandled [XmlParserException] from malformed SVGs.
///
/// Formats [imageUrl] via [UrlHelper.formatImageUrl] (handles relative paths
/// and full URLs). Use for path icons, course icons, avatars, and any API
/// image URL.
class AppCachedNetworkImage extends StatelessWidget {
  /// Raw image URL from API (relative e.g. /storage/... or full URL).
  /// When null or empty, [errorWidget] is shown.
  final String? imageUrl;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Clip and border radius for the image. Omit for no clipping.
  final BorderRadius? borderRadius;

  /// Shown while the image is loading.
  final Widget? placeholder;

  /// Shown when URL is invalid/empty or when the image fails to load.
  final Widget? errorWidget;

  /// When true, [imageUrl] is passed to [UrlHelper.formatImageUrl].
  /// Set to false if [imageUrl] is already a final full URL.
  final bool formatUrl;

  /// Color filter applied to SVG images (e.g. tint white for icons
  /// on a gradient background). Only affects SVG images; ignored for
  /// raster images.
  final Color? svgColor;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.formatUrl = true,
    this.svgColor,
  });

  /// Builds the effective image URL (formatted when [formatUrl] is true).
  static String? effectiveImageUrl(String? url, {bool formatUrl = true}) {
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (formatUrl) {
      final formatted = UrlHelper.formatImageUrl(trimmed);
      return formatted.isEmpty ? null : formatted;
    }
    return trimmed;
  }

  /// Checks if the URL points to an SVG image.
  static bool isSvgUrl(String url) {
    final path = Uri.tryParse(url.toLowerCase())?.path ?? url.toLowerCase();
    return path.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = effectiveImageUrl(imageUrl, formatUrl: formatUrl);

    if (effectiveUrl == null || effectiveUrl.isEmpty) {
      return _wrap(child: errorWidget ?? _defaultErrorWidget(context));
    }

    //* SVG images: safe pre-validated rendering
    if (isSvgUrl(effectiveUrl)) {
      return _wrap(
        child: _SafeNetworkSvg(
          url: effectiveUrl,
          width: width,
          height: height,
          fit: fit,
          color: svgColor,
          placeholder: placeholder ?? _defaultPlaceholder(context),
          errorWidget: errorWidget ?? _defaultErrorWidget(context),
        ),
      );
    }

    //* Raster images: CachedNetworkImage — fade-in effect instead of spinner
    return _wrap(
      child: CachedNetworkImage(
        imageUrl: effectiveUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) =>
            placeholder ?? _defaultPlaceholder(context),
        fadeInDuration: const Duration(milliseconds: 400),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeOut,
        fadeOutCurve: Curves.easeIn,
        errorWidget: (_, __, ___) =>
            errorWidget ?? _defaultErrorWidget(context),
      ),
    );
  }

  Widget _wrap({required Widget child}) {
    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  /// Placeholder shown while image loads — slim circular indicator on
  /// subtle background.
  Widget _defaultPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.surfaceContainerHighest;
    final indicatorColor = theme.colorScheme.primary;
    return ColoredBox(
      color: bgColor,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        child: Center(
          child: SizedBox(
            width: 60.w,
            height: 60.h,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget(BuildContext context) {
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: width != null && height != null
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 24,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

/// Safely loads and renders SVG images from network URLs.
///
/// Downloads SVG content via [HttpClient], validates it by attempting
/// compilation with [SvgStringLoader.loadBytes], and only renders
/// validated content using [SvgPicture.string]. Results are cached in
/// an in-memory LRU map (max [_maxCacheSize] entries) keyed by URL.
///
/// This prevents unhandled [XmlParserException] from malformed SVGs
/// returned by the API. When validation fails, [errorWidget] is shown.
class _SafeNetworkSvg extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget placeholder;
  final Widget errorWidget;

  const _SafeNetworkSvg({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  State<_SafeNetworkSvg> createState() => _SafeNetworkSvgState();
}

class _SafeNetworkSvgState extends State<_SafeNetworkSvg> {
  /// Maximum number of SVG entries in the in-memory cache.
  static const int _maxCacheSize = 100;

  /// In-memory LRU cache for validated SVG content.
  /// Key: URL, Value: SVG content string (null = invalid/failed).
  static final Map<String, String?> _svgCache = {};

  /// Ordered keys for LRU eviction.
  static final List<String> _cacheKeys = [];

  /// Shared HTTP client for SVG downloads.
  static final HttpClient _httpClient = HttpClient();

  late Future<String?> _svgFuture;

  @override
  void initState() {
    super.initState();
    _svgFuture = _loadAndValidateSvg(widget.url);
  }

  @override
  void didUpdateWidget(_SafeNetworkSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _svgFuture = _loadAndValidateSvg(widget.url);
    }
  }

  /// Downloads SVG content and pre-validates it by compiling with
  /// [SvgStringLoader]. Returns the SVG content string if valid,
  /// null otherwise.
  ///
  /// Handles edge cases:
  /// - HTTP errors (non-200 status)
  /// - Non-SVG content (e.g., HTML error page, raster image renamed .svg)
  /// - Malformed SVG XML (syntax errors caught by XmlParserException)
  /// - Network failures (timeouts, DNS errors, etc.)
  Future<String?> _loadAndValidateSvg(String url) async {
    // Return cached result
    if (_svgCache.containsKey(url)) {
      return _svgCache[url];
    }

    try {
      //* Download SVG content
      final request = await _httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != 200) {
        _putCache(url, null);
        return null;
      }

      //* Check content-type header for obvious non-SVG responses
      final contentType = response.headers.contentType?.mimeType ?? '';
      final isLikelySvg =
          contentType.isEmpty ||
          contentType.contains('svg') ||
          contentType.contains('xml') ||
          contentType.contains('text');

      if (!isLikelySvg) {
        //* Server returned a raster image or binary - not an SVG
        await response.drain<void>();
        _putCache(url, null);
        return null;
      }

      final content = await response.transform(utf8.decoder).join();

      //* Basic content validation: must contain <svg tag
      if (!content.contains('<svg')) {
        _putCache(url, null);
        return null;
      }

      //* Pre-validate by compiling SVG.
      //* Catches XmlParserException and other parsing errors before
      //* they become unhandled exceptions in the widget tree.
      //* The compiled result is also cached internally by flutter_svg
      //* (SvgCache) via the SvgStringLoader equality, so subsequent
      //* SvgPicture.string() calls with the same content will hit
      //* the compile cache and avoid double work.
      try {
        await SvgStringLoader(content).loadBytes(null);
      } catch (_) {
        _putCache(url, null);
        return null;
      }

      _putCache(url, content);
      return content;
    } catch (_) {
      _putCache(url, null);
      return null;
    }
  }

  /// Stores a value in the LRU cache, evicting the oldest entry if full.
  static void _putCache(String key, String? value) {
    if (!_svgCache.containsKey(key) && _cacheKeys.length >= _maxCacheSize) {
      final evicted = _cacheKeys.removeAt(0);
      _svgCache.remove(evicted);
    }
    _svgCache[key] = value;
    if (!_cacheKeys.contains(key)) {
      _cacheKeys.add(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _svgFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder;
        }

        final content = snapshot.data;
        if (content == null) {
          return widget.errorWidget;
        }

        return SvgPicture.string(
          content,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : null,
        );
      },
    );
  }
}
