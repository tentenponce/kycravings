import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class TutorialDetailsView extends StatelessWidget {
  final String title;
  final String message;

  const TutorialDetailsView({
    required this.title,
    required this.message,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: KycTextStyles.textStyle3Bold().copyWith(color: KycColors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(top: KycDimens.space5),
          child: Text(
            message,
            style: KycTextStyles.textStyle5Reg().copyWith(color: KycColors.white),
          ),
        )
      ],
    );
  }
}
