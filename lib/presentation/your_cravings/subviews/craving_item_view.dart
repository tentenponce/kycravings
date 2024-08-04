import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';

abstract final class CravingItemView {
  static TableRow build(
    BuildContext context, {
    required String cravingName,
    Iterable<String>? categories,
  }) {
    return TableRow(
      children: [
        InkWell(
          onTap: () => {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: KycDimens.space5,
              horizontal: KycDimens.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cravingName,
                  style: KycTextStyles.textStyle3Bold(),
                ),
                const SizedBox(height: KycDimens.space3),
                SizedBox(
                  child: Wrap(
                    spacing: KycDimens.space2,
                    runSpacing: KycDimens.space2,
                    children: (categories ?? []).map((category) => KycTag(label: category, isSelected: false)).toList(),
                  ),
                ),
                const SizedBox(height: KycDimens.space3),
                Text(
                  'Updated 4 days ago',
                  style: KycTextStyles.textStyle5Reg(),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: InkWell(
            onTap: () => {},
            child: const Icon(Icons.delete, color: KycColors.red),
          ),
        ),
      ],
    );
  }
}
