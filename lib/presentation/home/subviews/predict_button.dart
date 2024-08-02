import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_blurs.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class PredictButton extends StatefulWidget {
  const PredictButton({super.key});

  @override
  State<PredictButton> createState() => _PredictButtonState();
}

class _PredictButtonState extends State<PredictButton> {
  double predictButtonRadius = KycDimens.predictRadiusRegular;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('tap');
      },
      onTapDown: (_) => setState(() {
        predictButtonRadius = KycDimens.predictRadiusSmall;
      }),
      onTapUp: (_) => setState(() {
        predictButtonRadius = KycDimens.predictRadiusRegular;
      }),
      borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
      child: Ink(
        decoration: BoxDecoration(
          color: KycColors.white,
          border: Border.all(
            color: KycColors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
          boxShadow: KycBlurs.standardBlur,
        ),
        child: AnimatedContainer(
          alignment: Alignment.center,
          height: predictButtonRadius,
          width: predictButtonRadius,
          duration: const Duration(milliseconds: 150),
          child: Text(
            I18n.of(context).homePredictButton,
            style: KycTextStyles.textStyle1Bold(color: KycColors.primary),
          ),
        ),
      ),
    );
  }
}
