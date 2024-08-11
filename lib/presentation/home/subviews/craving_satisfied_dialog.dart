import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_filled.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_outlined.dart';

class CravingSatisfiedDialog extends StatefulWidget {
  static const isOkay = 'isOkay';
  static const isDontShowEnabled = 'isDontShowEnabled';
  const CravingSatisfiedDialog({super.key});

  @override
  State<CravingSatisfiedDialog> createState() => _CravingSatisfiedDialogState();
}

class _CravingSatisfiedDialogState extends State<CravingSatisfiedDialog> {
  bool _isDontShowEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: KycColors.white,
      child: Container(
        padding: const EdgeInsets.all(KycDimens.space9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              I18n.of(context).homeCravingSatisfiedDialogTitle,
              style: KycTextStyles.textStyle4Bold(),
            ),
            const SizedBox(height: KycDimens.space7),
            Text(
              I18n.of(context).homeCravingSatisfiedDialogMessage,
              style: KycTextStyles.textStyle5Reg(),
            ),
            const SizedBox(height: KycDimens.space7),
            Row(
              children: [
                Checkbox(
                  value: _isDontShowEnabled,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  checkColor: KycColors.primary,
                  activeColor: KycColors.lightPrimary,
                  side: const BorderSide(color: KycColors.primary),
                  onChanged: (isChecked) => setState(() {
                    _isDontShowEnabled = isChecked ?? false;
                  }),
                ),
                Text(
                  I18n.of(context).genericDoNotShowThisAgain,
                  style: KycTextStyles.textStyle5Reg(),
                ),
              ],
            ),
            const SizedBox(height: KycDimens.space9),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KycButtonOutlined(
                  title: I18n.of(context).genericCancel,
                  onPressed: () => Navigator.pop(
                    context,
                    {
                      CravingSatisfiedDialog.isOkay: false,
                      CravingSatisfiedDialog.isDontShowEnabled: _isDontShowEnabled,
                    },
                  ),
                  isSmall: true,
                ),
                const SizedBox(width: KycDimens.space4),
                KycButtonFilled(
                  title: I18n.of(context).genericOk,
                  onPressed: () => Navigator.pop(
                    context,
                    {
                      CravingSatisfiedDialog.isOkay: true,
                      CravingSatisfiedDialog.isDontShowEnabled: _isDontShowEnabled,
                    },
                  ),
                  isSmall: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
