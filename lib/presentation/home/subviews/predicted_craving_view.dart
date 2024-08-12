import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';
import 'package:shimmer/shimmer.dart';

class PredictedCravingView extends StatelessWidget {
  final CravingModel predictedCraving;
  final bool isSwipePredicting;
  const PredictedCravingView({
    required this.predictedCraving,
    required this.isSwipePredicting,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0 || details.delta.dx < 0) {
          unawaited(context.read<HomeCubit>().onSwipePrediction());
        }
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 150),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    if (!isSwipePredicting)
                      Column(
                        children: [
                          Assets.images.icStarsLeft.svg(width: KycDimens.icon5, height: KycDimens.icon5),
                          const SizedBox(height: KycDimens.space10),
                        ],
                      ),
                    Expanded(
                      flex: 3,
                      child: !isSwipePredicting
                          ? AutoSizeText(
                              predictedCraving.name,
                              style: KycTextStyles.textStyle1Bold().copyWith(height: 1.1),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            )
                          : Shimmer.fromColors(
                              baseColor: KycColors.lightGray,
                              highlightColor: KycColors.neutral95,
                              period: const Duration(milliseconds: 1000),
                              child: Container(
                                height: KycDimens.predictShimmerHeight,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: KycColors.lightGray,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(KycDimens.radius2),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    if (!isSwipePredicting)
                      Column(
                        children: [
                          Assets.images.icStarsRight.svg(width: KycDimens.icon5, height: KycDimens.icon5),
                          const SizedBox(height: KycDimens.space10),
                        ],
                      ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: KycDimens.space3),
                if (!isSwipePredicting)
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
            const SizedBox(height: KycDimens.space5),
            Text(
              I18n.of(context).homeSwipeForMore,
              style: KycTextStyles.textStyle6Reg().copyWith(color: KycColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}
