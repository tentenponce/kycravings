import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/home/home_view.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/splash/cubits/splash_cubit.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget with ViewCubitMixin<SplashCubit> {
  const SplashView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return const _SplashView();
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  @override
  void initState() {
    context.read<SplashCubit>().navigateToHome = () async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => HomeView(),
        ),
      );
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.primary,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(KycDimens.space5),
              decoration: BoxDecoration(
                color: KycColors.white,
                borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
              ),
              child: Lottie.asset(Assets.lottie.logo, height: KycDimens.icon11, width: KycDimens.icon11),
            ),
            const SizedBox(height: KycDimens.space5),
            Text(
              I18n.of(context).splashTitle,
              style: KycTextStyles.textStyle2Bold(color: KycColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
