import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class KycTag extends StatelessWidget {
  const KycTag({
    required this.label,
    required this.isSelected,
    this.onPressed,
    this.onLongPress,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KycDimens.tagHeight,
      child: OutlinedButton(
        onLongPress: onLongPress,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: KycDimens.space7, vertical: 0),
          side: const BorderSide(color: KycColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KycDimens.radius6),
          ),
          backgroundColor: isSelected ? KycColors.primary : null,
        ),
        child: Text(
          label,
          style: KycTextStyles.textStyle5Reg(color: isSelected ? KycColors.white : KycColors.primary),
        ),
      ),
    );
  }
}
