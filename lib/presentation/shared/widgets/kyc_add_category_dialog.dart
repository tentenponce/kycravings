import 'package:flutter/widgets.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/utils/dialog_utils.dart';

abstract final class KycAddCategoryDialog {
  static Future<String?> show({
    required BuildContext context,
    required TextEditingController categoryController,
    required void Function(String value) onOk,
    required void Function(String value) onTextChanged,
    required Widget errorMessage,
  }) async {
    categoryController.text = '';
    return DialogUtils.showTextInputDialog(
      context: context,
      onOk: onOk,
      title: I18n.of(context).addCravingsCategoryDialogTitle,
      textEditingController: categoryController,
      onTextChanged: onTextChanged,
      errorMessage: errorMessage,
      ok: I18n.of(context).genericAdd,
    );
  }
}
