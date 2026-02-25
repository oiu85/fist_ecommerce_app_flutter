import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Utility to show a full-screen image preview (zoomable) for a network image URL.
///
/// Use from menu product image tap, store item details image tap, or anywhere
/// a network image should open in a store-style full-screen viewer.
void showFullScreenImagePreview(BuildContext context, String imageUrl) {
  if (imageUrl.isEmpty ||
      (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://'))) {
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.error, color: Colors.white, size: 48),
          ),
        ),
      ),
    ),
  );
}
