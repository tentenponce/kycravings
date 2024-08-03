import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';

class KycButtonOutlined extends StatelessWidget {
  const KycButtonOutlined({
    required VoidCallback onPressed,
    required String title,
    super.key,
    Color? color,
    bool isSmall = false,
  })  : _onPressed = onPressed,
        _title = title,
        _isSmall = isSmall,
        _color = color;

  final VoidCallback _onPressed;
  final String _title;
  final bool _isSmall;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _onPressed,
      style: OutlinedButton.styleFrom(
        padding: _isSmall
            ? const EdgeInsets.all(KycDimens.paddingButtonSmall)
            : const EdgeInsets.all(KycDimens.paddingButtonNormal),
        side: BorderSide(color: _color ?? KycColors.primary),
      ),
      child: Text(
        _title,
        style: TextStyle(color: _color ?? KycColors.primary),
      ),
    );
  }
}
