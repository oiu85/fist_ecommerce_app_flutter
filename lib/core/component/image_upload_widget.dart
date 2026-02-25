import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../localization/app_text.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import 'app_snackbar.dart';
import 'dotted_border_painter.dart';

/// Reusable image upload widget.
/// 
/// Allows selecting and displaying images with a consistent design pattern.
/// Supports both local file selection and network image URLs for editing.
class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({
    super.key,
    this.initialImageUrl,
    this.onImageSelected,
    this.uploadTextKey,
    this.formatTextKey,
    this.width,
    this.height,
  });

  /// Initial image URL from network (for editing existing items)
  final String? initialImageUrl;

  /// Callback when an image is selected
  final void Function(File? imageFile)? onImageSelected;

  /// Locale key for upload text (e.g., "Upload Photo")
  final String? uploadTextKey;

  /// Locale key for format text (e.g., "Png, Jpeg Max Size 500kb")
  final String? formatTextKey;

  /// Width of the upload widget (default: 198.w)
  final double? width;

  /// Height of the upload widget (default: 175.h)
  final double? height;

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        widget.onImageSelected?.call(_selectedImage);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Failed to pick image: ${e.toString()}',
          translation: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasImage = _selectedImage != null || widget.initialImageUrl != null;
    final width = widget.width ?? 198.w;
    final height = widget.height ?? 175.h;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.52.r),
          ),
        ),
        child: Stack(
          children: [
            //* Image preview or placeholder
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(20.52.r),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      )
                    : widget.initialImageUrl != null
                        ? Image.network(
                            widget.initialImageUrl!,
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder(
                                colorScheme,
                                textTheme,
                                width,
                                height,
                              );
                            },
                          )
                        : _buildPlaceholder(
                            colorScheme,
                            textTheme,
                            width,
                            height,
                          ),
              )
            else
              _buildPlaceholder(
                colorScheme,
                textTheme,
                width,
                height,
              ),
            // Overlay with camera icon when image exists
            if (hasImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20.52.r),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(7.5.w),
                      decoration: ShapeDecoration(
                        color: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.5.r),
                        ),
                      ),
                      child: Assets.images.icons.camera.svg(
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(
    ColorScheme colorScheme,
    TextTheme textTheme,
    double width,
    double height,
  ) {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: colorScheme.primary,
        strokeWidth: 1.w,
        dashWidth: 4.w,
        dashSpace: 3.w,
        borderRadius: 20.52.r,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(7.5.w),
              decoration: ShapeDecoration(
                color: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(37.5.r),
                ),
              ),
              child: Assets.images.icons.camera.svg(
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (widget.uploadTextKey != null) ...[
              SizedBox(height: 16.h),
              AppText(
                widget.uploadTextKey!,
                translation: true,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 12.sp,
                  fontFamily: FontFamily.sora,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (widget.formatTextKey != null)
              AppText(
                widget.formatTextKey!,
                translation: true,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.sora,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
