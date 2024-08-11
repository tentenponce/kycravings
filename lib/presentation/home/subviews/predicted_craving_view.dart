import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';

class PredictedCravingView extends StatelessWidget {
  final CravingModel predictedCraving;
  const PredictedCravingView({
    required this.predictedCraving,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: KycDimens.space6),
            Assets.images.icArrowLeftCircle.svg(width: KycDimens.icon6, height: KycDimens.icon6),
            const SizedBox(width: KycDimens.space6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Assets.images.icStarsLeft.svg(width: KycDimens.icon5, height: KycDimens.icon5),
                          const SizedBox(height: KycDimens.space10),
                        ],
                      ),
                      Expanded(
                        child: AutoSizeText(
                          predictedCraving.name,
                          style: KycTextStyles.textStyle1Bold().copyWith(height: 1.1),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      Column(
                        children: [
                          Assets.images.icStarsRight.svg(width: KycDimens.icon5, height: KycDimens.icon5),
                          const SizedBox(height: KycDimens.space10),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: KycDimens.space3),
                  Wrap(
                    spacing: KycDimens.space2,
                    runSpacing: KycDimens.space2,
                    alignment: WrapAlignment.center,
                    children: predictedCraving.categories
                        .map(
                          (category) => KycTag(
                            label: category.name,
                            isSelected: false,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: KycDimens.space6),
            Assets.images.icArrowRightCircle.svg(width: KycDimens.icon6, height: KycDimens.icon6),
            const SizedBox(width: KycDimens.space6),
          ],
        ),
        const SizedBox(height: KycDimens.space5),
        Text(
          I18n.of(context).homeSwipeForMore,
          style: KycTextStyles.textStyle6Reg().copyWith(color: KycColors.gray),
        ),
      ],
    );
  }
}
