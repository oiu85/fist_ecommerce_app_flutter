import 'package:flutter/material.dart';

import '../../../../core/localization/app_text.dart';

class CartTotalRow extends StatelessWidget {
  const CartTotalRow({
    super.key,
    required this.labelKey,
    this.valueKey,
    this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String labelKey;
  final String? valueKey;
  final String? value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final valueText = valueKey ?? value ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(labelKey, translation: true, style: labelStyle, isAutoScale: true, maxLines: 1),
        Flexible(
          child: AppText(
            valueText,
            translation: valueKey != null,
            style: valueStyle,
            textAlign: TextAlign.end,
            maxLines: 1,
            isAutoScale: true,
          ),
        ),
      ],
    );
  }
}
