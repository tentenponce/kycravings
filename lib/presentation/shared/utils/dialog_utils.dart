import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/utils/string_utils.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_filled.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_outlined.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_text_field.dart';

abstract final class DialogUtils {
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required void Function() onOk,
    void Function()? onCancel,
    String? title,
    String? message,
    String? cancel,
    String? ok,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: KycColors.white,
            title: Text(
              title ?? '',
              style: KycTextStyles.textStyle4Bold(),
            ),
            content: !StringUtils.isNullOrEmpty(message)
                ? Text(
                    message!,
                    style: KycTextStyles.textStyle5Reg(),
                  )
                : const SizedBox(),
            actions: <Widget>[
              KycButtonOutlined(
                title: cancel ?? I18n.of(context).genericCancel,
                onPressed: onCancel ?? () => Navigator.pop(context),
                isSmall: true,
              ),
              KycButtonFilled(
                title: ok ?? I18n.of(context).genericOk,
                onPressed: onOk,
                isSmall: true,
              ),
            ],
          );
        });
  }

  static Future<String?> showTextInputDialog({
    required BuildContext context,
    required void Function(String value) onOk,
    void Function()? onCancel,
    String? title,
    String? message,
    TextEditingController? textEditingController,
    void Function(String)? onTextChanged,
    Widget? errorMessage,
    String? cancel,
    String? ok,
  }) async {
    textEditingController ??= TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: KycColors.white,
            title: Text(
              title ?? '',
              style: KycTextStyles.textStyle4Bold(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KycTextField(
                  controller: textEditingController,
                  onChanged: onTextChanged,
                ),
                const SizedBox(height: KycDimens.space3),
                errorMessage ?? const SizedBox(),
              ],
            ),
            actions: <Widget>[
              KycButtonOutlined(
                title: cancel ?? I18n.of(context).genericCancel,
                onPressed: onCancel ?? () => Navigator.pop(context),
                isSmall: true,
              ),
              KycButtonFilled(
                title: ok ?? I18n.of(context).genericOk,
                onPressed: () => onOk(textEditingController!.text),
                isSmall: true,
              ),
            ],
          );
        });
  }
}
