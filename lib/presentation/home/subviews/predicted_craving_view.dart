import 'package:flutter/widgets.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class PredictedCravingView extends StatelessWidget {
  final String predictedCraving;
  const PredictedCravingView({
    required this.predictedCraving,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Assets.images.icStarsLeft.svg(width: KycDimens.icon4, height: KycDimens.icon4),
            const SizedBox(height: KycDimens.space10),
          ],
        ),
        Text(
          predictedCraving,
          style: KycTextStyles.textStyle1Bold(),
        ),
        Column(
          children: [
            Assets.images.icStarsRight.svg(width: KycDimens.icon4, height: KycDimens.icon4),
            const SizedBox(height: KycDimens.space10),
          ],
        ),
      ],
    );
  }
}
