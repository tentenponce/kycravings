import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/add_cravings_history/add_cravings_history_view.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/cravings_history/cubits/cravings_history_cubit.dart';
import 'package:kycravings/presentation/cravings_history/states/cravings_history_state.dart';
import 'package:kycravings/presentation/cravings_history/subviews/craving_history_item_view.dart';
import 'package:kycravings/presentation/cravings_history/subviews/craving_history_shimmer_item_view.dart';
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

class _CravingsHistoryView extends StatefulWidget {
  const _CravingsHistoryView();

  @override
  State<_CravingsHistoryView> createState() => _CravingsHistoryViewState();
}

class _CravingsHistoryViewState extends State<_CravingsHistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    context.read<CravingsHistoryCubit>().onInitialLoad = _scrollListener;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Load more data when scrolled to the bottom
  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent - 10; // Use a small offset to account for rounding
    final currentScroll = _scrollController.offset;

    if (currentScroll >= maxScroll) {
      unawaited(context.read<CravingsHistoryCubit>().onScrollBottom());
    }
  }

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
        padding: const EdgeInsets.only(bottom: KycDimens.space14),
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: BlocBuilder<CravingsHistoryCubit, CravingsHistoryState>(
          builder: (context, state) {
            return !state.isLoading
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: KycDimens.space6),
                    child: Table(
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
                    ),
                  )
                : const Column(
                    children: [
                      SizedBox(height: KycDimens.space6),
                      CravingHistoryShimmerItemView(),
                      CravingHistoryShimmerItemView(),
                      CravingHistoryShimmerItemView(),
                      CravingHistoryShimmerItemView(),
                      CravingHistoryShimmerItemView(),
                      CravingHistoryShimmerItemView(),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isAdded = await Navigator.of(context).push(
            MaterialPageRoute<bool?>(
              builder: (context) => const AddCravingsHistoryView(),
            ),
          );

          if ((isAdded ?? false) && context.mounted) {
            await context.read<CravingsHistoryCubit>().getCravings();
          }
        },
        backgroundColor: KycColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
        ),
        child: const Icon(Icons.add, color: KycColors.white),
      ),
    );
  }
}
