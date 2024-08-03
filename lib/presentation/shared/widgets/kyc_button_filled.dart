import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';

class KycButtonFilled extends StatelessWidget {
  const KycButtonFilled({
    required VoidCallback onPressed,
    required String title,
    super.key,
    bool isSmall = false,
  })  : _onPressed = onPressed,
        _title = title,
        _isSmall = isSmall;

  final VoidCallback _onPressed;
  final String _title;
  final bool _isSmall;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPressed,
      style: TextButton.styleFrom(
        padding: _isSmall
            ? const EdgeInsets.all(KycDimens.paddingButtonSmall)
            : const EdgeInsets.all(KycDimens.paddingButtonNormal),
        backgroundColor: KycColors.primary,
      ),
      child: Text(_title, style: const TextStyle(color: KycColors.white)),
    );
  }
}
