import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/add_cravings_history/cubits/add_cravings_history_cubit.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';

class AddCravingsHistoryItemView extends StatelessWidget {
  final CravingModel cravingModel;
  const AddCravingsHistoryItemView({
    required this.cravingModel,
    super.key,
  });

  Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2024),
          lastDate: DateTime(DateTime.now().year + 1),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedDate = await Navigator.of(context).push(_datePickerRoute(
          context,
          DateTime.now().millisecondsSinceEpoch,
        ));

        if (context.mounted && selectedDate != null) {
          await context.read<AddCravingsHistoryCubit>().onAddCravingHistory(cravingModel, selectedDate);

          if (context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
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
                children:
                    cravingModel.categories.map((category) => KycTag(label: category.name, isSelected: false)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
