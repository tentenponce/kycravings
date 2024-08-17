import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:lottie/lottie.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).aboutTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => Navigator.of(context).pop(),
      ),
      body: Container(
        padding: const EdgeInsets.all(KycDimens.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(KycDimens.space5),
              child: Column(
                children: [
                  Lottie.asset(Assets.lottie.logo, height: KycDimens.icon11),
                  Text(
                    I18n.of(context).aboutSubTitle,
                    style: KycTextStyles.textStyle3Bold(),
                  ),
                  const SizedBox(height: KycDimens.space2),
                ],
              ),
            ),
            const Divider(color: KycColors.lightGray),
            const SizedBox(height: KycDimens.space4),
            Text(
              I18n.of(context).aboutMessage,
              textAlign: TextAlign.left,
              style: KycTextStyles.textStyle4Reg(),
            ),
          ],
        ),
      ),
    );
  }
}
