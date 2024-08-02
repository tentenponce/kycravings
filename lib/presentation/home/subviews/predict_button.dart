import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_blurs.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class PredictButton extends StatelessWidget {
  const PredictButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: KycDimens.predictRadius,
      width: KycDimens.predictRadius,
      decoration: BoxDecoration(
        color: KycColors.white,
        border: Border.all(
          color: KycColors.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
        boxShadow: KycBlurs.standardBlur,
      ),
      alignment: Alignment.center,
      child: Text(
        I18n.of(context).homePredictButton,
        style: KycTextStyles.h1Bold(color: KycColors.primary),
      ),
    );
  }
}
