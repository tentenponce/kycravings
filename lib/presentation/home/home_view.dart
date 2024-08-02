import 'package:flutter/material.dart';
import 'package:kycravings/presentation/home/subviews/predict_button.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).appName,
        leadingIcon: const Icon(
          Icons.menu,
          color: KycColors.white,
        ),
        onLeadingIconClick: () {
          // TODO: show drawer
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PredictButton(),
            const SizedBox(height: KycDimens.space6),
            Text(
              I18n.of(context).homeShakeYourPhone,
            ),
          ],
        ),
      ),
    );
  }
}
