import 'package:flutter/material.dart';
import 'package:kycravings/domain/models/craving_history_model.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/utils/date_time_utils.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';

abstract final class CravingHistoryItemView {
  static TableRow build(
    BuildContext context, {
    required CravingHistoryModel cravingHistoryModel,
    VoidCallback? onDeleteClick,
  }) {
    return TableRow(
      children: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: KycDimens.space5,
              horizontal: KycDimens.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cravingHistoryModel.cravingModel.name,
                  style: KycTextStyles.textStyle3Bold(),
                ),
                const SizedBox(height: KycDimens.space3),
                SizedBox(
                  child: Wrap(
                    spacing: KycDimens.space2,
                    runSpacing: KycDimens.space2,
                    children: cravingHistoryModel.cravingModel.categories
                        .map((category) => KycTag(label: category.name, isSelected: false))
                        .toList(),
                  ),
                ),
                const SizedBox(height: KycDimens.space3),
                Text(
                  I18n.of(context).yourCravingsDateMessage(DateTimeUtils.ago(cravingHistoryModel.createdAt)),
                  style: KycTextStyles.textStyle5Reg(),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: InkWell(
            onTap: onDeleteClick,
            child: const Icon(Icons.delete, color: KycColors.red),
          ),
        ),
      ],
    );
  }
}
