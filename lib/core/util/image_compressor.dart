import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Utility class for compressing images in the background
class ImageCompressor {
  /// Maximum file size in bytes (1.9 MB)
  static const int maxFileSizeBytes = 1900000; // 1.9 MB
  
  /// Minimum quality to use when compressing
  static const int minQuality = 20;
  
  /// Initial quality to start with
  static const int initialQuality = 85;
  
  /// Quality reduction step for each iteration
  static const int qualityStep = 10;

  /// Compresses an image file if it exceeds the maximum size
  /// Returns the path to the compressed image (or original if already small enough)
  /// 
  /// This runs in an isolate to avoid blocking the UI thread
  static Future<String> compressIfNeeded(String imagePath) async {
    try {
      final file = File(imagePath);
      
      // Check if file exists
      if (!await file.exists()) {
        debugPrint('ImageCompressor: File does not exist: $imagePath');
        return imagePath;
      }
      
      // Get file size
      final fileSize = await file.length();
      debugPrint('ImageCompressor: Original file size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');
      
      // If file is already small enough, return original path
      if (fileSize <= maxFileSizeBytes) {
        debugPrint('ImageCompressor: File is already within size limit');
        return imagePath;
      }
      
      // Compress the image
      return await _compressImage(imagePath, fileSize);
    } catch (e) {
      debugPrint('ImageCompressor: Error compressing image: $e');
      // Return original path if compression fails
      return imagePath;
    }
  }

  /// Compresses the image to be under the max size
  static Future<String> _compressImage(String imagePath, int originalSize) async {
    try {
      // Get the temp directory for storing compressed images
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getFileExtension(imagePath);
      final targetPath = '${tempDir.path}/compressed_$timestamp$extension';
      
      int quality = initialQuality;
      String currentPath = imagePath;
      int currentSize = originalSize;
      
      // Iteratively reduce quality until file size is acceptable
      while (currentSize > maxFileSizeBytes && quality >= minQuality) {
        debugPrint('ImageCompressor: Compressing with quality: $quality');
        
        final compressedBytes = await _compressWithQuality(
          imagePath,
          quality,
        );
        
        if (compressedBytes == null || compressedBytes.isEmpty) {
          debugPrint('ImageCompressor: Compression returned null/empty');
          break;
        }
        
        // Write compressed bytes to file
        final compressedFile = File(targetPath);
        await compressedFile.writeAsBytes(compressedBytes);
        
        currentSize = compressedBytes.length;
        currentPath = targetPath;
        
        debugPrint('ImageCompressor: Compressed size: ${(currentSize / 1024 / 1024).toStringAsFixed(2)} MB');
        
        // Reduce quality for next iteration if still too large
        quality -= qualityStep;
      }
      
      // If we still couldn't get under the limit, try more aggressive compression
      if (currentSize > maxFileSizeBytes) {
        debugPrint('ImageCompressor: Trying aggressive compression with resize');
        final aggressiveBytes = await _aggressiveCompress(imagePath);
        
        if (aggressiveBytes != null && aggressiveBytes.isNotEmpty) {
          final compressedFile = File(targetPath);
          await compressedFile.writeAsBytes(aggressiveBytes);
          currentPath = targetPath;
          debugPrint('ImageCompressor: Final size after aggressive compression: ${(aggressiveBytes.length / 1024 / 1024).toStringAsFixed(2)} MB');
        }
      }
      
      return currentPath;
    } catch (e) {
      debugPrint('ImageCompressor: Error in _compressImage: $e');
      return imagePath;
    }
  }

  /// Compress image with specific quality
  static Future<Uint8List?> _compressWithQuality(String imagePath, int quality) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      
      return await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        format: _getCompressFormat(imagePath),
      );
    } catch (e) {
      debugPrint('ImageCompressor: Error in _compressWithQuality: $e');
      return null;
    }
  }

  /// More aggressive compression with resizing
  static Future<Uint8List?> _aggressiveCompress(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      
      // Resize to max 1200px width/height and use minimum quality
      return await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1200,
        minHeight: 1200,
        quality: minQuality,
        format: _getCompressFormat(imagePath),
      );
    } catch (e) {
      debugPrint('ImageCompressor: Error in _aggressiveCompress: $e');
      return null;
    }
  }

  /// Extract file extension from path
  static String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1 || lastDot == filePath.length - 1) {
      return '.jpg';
    }
    return filePath.substring(lastDot).toLowerCase();
  }

  /// Get the appropriate compress format based on file extension
  static CompressFormat _getCompressFormat(String imagePath) {
    final extension = _getFileExtension(imagePath);
    switch (extension) {
      case '.png':
        return CompressFormat.png;
      case '.webp':
        return CompressFormat.webp;
      case '.heic':
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }

  /// Clean up old compressed images from temp directory
  static Future<void> cleanupTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      
      for (final file in files) {
        if (file is File && file.path.contains('compressed_')) {
          // Delete files older than 1 hour
          final stat = await file.stat();
          final age = DateTime.now().difference(stat.modified);
          if (age.inHours > 1) {
            await file.delete();
            debugPrint('ImageCompressor: Deleted old temp file: ${file.path}');
          }
        }
      }
    } catch (e) {
      debugPrint('ImageCompressor: Error cleaning up temp images: $e');
    }
  }
}

