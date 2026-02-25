import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color_extension.dart';
import '../../gen/assets.gen.dart';
import 'confirmation_dialog.dart';

/// Reusable slidable list row: swipe left to reveal delete action, tap row for primary action.
/// Used by Store and Clients list rows.
class SlidableListRow extends StatefulWidget {
  const SlidableListRow({
    super.key,
    required this.child,
    required this.deleteTitleKey,
    required this.deleteMessageKey,
    this.confirmTextKey,
    required this.onDelete,
    this.onTap,
    this.slideOffset = -0.2,
  });

  /// The row content (slides horizontally).
  final Widget child;

  /// Locale key for delete confirmation title.
  final String deleteTitleKey;

  /// Locale key for delete confirmation message.
  final String deleteMessageKey;

  /// Locale key for confirm button (e.g. [LocaleKeys.common_confirm]).
  final String? confirmTextKey;

  /// Called when user confirms delete.
  final VoidCallback onDelete;

  /// Called when user taps the row (not the delete area).
  final VoidCallback? onTap;

  /// How far the row slides (negative = left). Default -0.2.
  final double slideOffset;

  @override
  State<SlidableListRow> createState() => _SlidableListRowState();
}

class _SlidableListRowState extends State<SlidableListRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.slideOffset, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSlide() {
    if (_isSliding) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() => _isSliding = !_isSliding);
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: widget.deleteTitleKey,
      message: widget.deleteMessageKey,
      confirmText: widget.confirmTextKey,
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorExtension>()!;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < -5 && !_isSliding) _handleSlide();
        if (details.delta.dx > 5 && _isSliding) _handleSlide();
      },
      onTap: () {
        if (_isSliding) {
          _handleSlide();
        } else {
          widget.onTap?.call();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                color: colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                    onTap: _handleDelete,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: colorScheme.onError.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: Assets.images.icons.delete.svg(
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onError,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              height: 42.h,
              decoration: ShapeDecoration(
                color: appColors.componentBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
