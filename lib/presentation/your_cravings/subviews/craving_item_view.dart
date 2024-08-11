import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kycravings/domain/core/utils/date_time_utils.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';

abstract final class CravingItemView {
  static TableRow build(
    BuildContext context, {
    required CravingModel cravingModel,
    VoidCallback? onItemClick,
    VoidCallback? onDeleteClick,
  }) {
    return TableRow(
      children: [
        InkWell(
          onTap: onItemClick,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: KycDimens.space5,
              horizontal: KycDimens.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cravingModel.name,
                  style: KycTextStyles.textStyle4Bold(),
                ),
                const SizedBox(height: KycDimens.space3),
                SizedBox(
                  child: Wrap(
                    spacing: KycDimens.space2,
                    runSpacing: KycDimens.space2,
                    children: cravingModel.categories
                        .map((category) => KycTag(label: category.name, isSelected: false))
                        .toList(),
                  ),
                ),
                const SizedBox(height: KycDimens.space3),
                Text(
                  I18n.of(context).yourCravingsDateMessage(GetIt.instance<DateTimeUtils>().ago(cravingModel.updatedAt)),
                  style: KycTextStyles.textStyle6Reg(),
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
