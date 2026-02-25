

import '../config/api_config.dart';

//* Utility class for URL formatting and manipulation

class UrlHelper {
  UrlHelper._();

  static String formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    // Check if it's already a full URL
    if (url.startsWith('http://') || url.startsWith('https://')) {
      // Special handling for ui-avatars.com - force PNG format
      if (url.contains('ui-avatars.com')) {
        // If format parameter is not present, add it
        if (!url.contains('format=')) {
          final separator = url.contains('?') ? '&' : '?';
          return '$url${separator}format=png';
        }
      }
      return url;
    }
    
    // Remove /api from baseUrl and append the relative path
    final baseUrlWithoutApi = ApiConfig.baseUrl.replaceAll('/api', '');
    
    // Ensure proper path formatting (avoid double slashes)
    if (url.startsWith('/')) {
      return '$baseUrlWithoutApi$url';
    } else {
      return '$baseUrlWithoutApi/$url';
    }
  }
}
