import 'package:flutter/material.dart';

import '../../../../core/component/app_ghost_button.dart';
import '../../../../core/localization/locale_keys.g.dart';

//* Cancel button — uses AppGhostButton (background, no border).
class AddProductCancelButton extends StatelessWidget {
  const AddProductCancelButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppGhostButton(
      labelKey: LocaleKeys.addProduct_cancel,
      onPressed: onPressed,
    );
  }
}
