import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_blurs.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:lottie/lottie.dart';

class PredictButton extends StatefulWidget {
  const PredictButton({super.key});

  @override
  State<PredictButton> createState() => _PredictButtonState();
}

class _PredictButtonState extends State<PredictButton> {
  double _predictButtonRadius = KycDimens.predictRadiusRegular;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: context.read<HomeCubit>().predict,
      onTapDown: (_) => setState(() {
        _predictButtonRadius = KycDimens.predictRadiusPressed;
      }),
      onTapUp: (_) => setState(() {
        _predictButtonRadius = KycDimens.predictRadiusRegular;
      }),
      onTapCancel: () => setState(() {
        _predictButtonRadius = KycDimens.predictRadiusRegular;
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
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          return AnimatedContainer(
            alignment: Alignment.center,
            height: state.predictedCraving == null ? _predictButtonRadius : KycDimens.predictRadiusSmall,
            width: state.predictedCraving == null ? _predictButtonRadius : KycDimens.predictRadiusSmall,
            duration: const Duration(milliseconds: 150),
            child: state.isPredicting
                ? Lottie.asset(Assets.lottie.bulb)
                : Text(
                    state.predictedCraving == null
                        ? I18n.of(context).homePredictButton
                        : I18n.of(context).homePredictAgainButton,
                    style: state.predictedCraving == null
                        ? KycTextStyles.textStyle2Bold(color: KycColors.primary)
                        : KycTextStyles.textStyle5Bold(color: KycColors.primary),
                    textAlign: TextAlign.center,
                  ),
          );
        }),
      ),
    );
  }
}
