import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
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
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          context.read<HomeCubit>().predict();
          _loading = true;
          Future.delayed(
            const Duration(milliseconds: 1000),
            () => {if (mounted) setState(() => _loading = false)},
          );
        });
      },
      onTapDown: (_) => setState(() {
        _predictButtonRadius = KycDimens.predictRadiusSmall;
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
        child: AnimatedContainer(
          alignment: Alignment.center,
          height: _predictButtonRadius,
          width: _predictButtonRadius,
          duration: const Duration(milliseconds: 150),
          child: _loading
              ? Lottie.asset(Assets.lottie.bulb)
              : Text(
                  I18n.of(context).homePredictButton,
                  style: KycTextStyles.textStyle1Bold(color: KycColors.primary),
                ),
        ),
      ),
    );
  }
}
