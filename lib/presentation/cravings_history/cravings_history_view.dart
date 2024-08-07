import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/cravings_history/cubits/cravings_history_cubit.dart';
import 'package:kycravings/presentation/cravings_history/states/cravings_history_state.dart';
import 'package:kycravings/presentation/cravings_history/subviews/craving_history_item_view.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/utils/dialog_utils.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';

class CravingsHistoryView extends StatelessWidget with ViewCubitMixin<CravingsHistoryCubit> {
  const CravingsHistoryView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return const _CravingsHistoryView();
  }
}

class _CravingsHistoryView extends StatelessWidget {
  const _CravingsHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).cravingsHistoryTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: KycDimens.space6),
          child: BlocBuilder<CravingsHistoryCubit, CravingsHistoryState>(
            builder: (context, state) {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FixedColumnWidth(KycDimens.space15),
                },
                children: state.cravingsHistory
                    .map((cravingHistory) => CravingHistoryItemView.build(
                          context,
                          cravingHistoryModel: cravingHistory,
                          onDeleteClick: () async => DialogUtils.showConfirmDialog(
                            context: context,
                            title: I18n.of(context).cravingsHistoryDeleteDialogTitle,
                            message: I18n.of(context).cravingsHistoryDeleteDialogMessage,
                            onOk: () {
                              context.read<CravingsHistoryCubit>().onCravingDelete(cravingHistory.id);
                              Navigator.pop(context);
                            },
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
