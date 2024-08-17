import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/add_cravings_history/cubits/add_cravings_history_cubit.dart';
import 'package:kycravings/presentation/add_cravings_history/states/add_cravings_history_state.dart';
import 'package:kycravings/presentation/add_cravings_history/subviews/add_cravings_history_item_view.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/your_cravings/subviews/craving_shimmer_item_view.dart';

class AddCravingsHistoryView extends StatelessWidget with ViewCubitMixin<AddCravingsHistoryCubit> {
  const AddCravingsHistoryView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _AddCravingsHistoryView();
  }
}

class _AddCravingsHistoryView extends StatefulWidget {
  @override
  State<_AddCravingsHistoryView> createState() => _AddCravingsHistoryViewState();
}

class _AddCravingsHistoryViewState extends State<_AddCravingsHistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    context.read<AddCravingsHistoryCubit>().onInitialLoad = _scrollListener;
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
      unawaited(context.read<AddCravingsHistoryCubit>().onScrollBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).addCravingsHistoryTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: KycDimens.space6),
          child: BlocBuilder<AddCravingsHistoryCubit, AddCravingsHistoryState>(
            builder: (context, state) {
              return !state.isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KycDimens.space8),
                          child: Text(
                            I18n.of(context).addCravingsHistoryMessage,
                            style: KycTextStyles.textStyle6Reg(),
                          ),
                        ),
                        ...state.cravings.map((craving) => AddCravingsHistoryItemView(cravingModel: craving)),
                      ],
                    )
                  : const Column(
                      children: [
                        SizedBox(height: KycDimens.space6),
                        CravingShimmerItemView(),
                        CravingShimmerItemView(),
                        CravingShimmerItemView(),
                        CravingShimmerItemView(),
                        CravingShimmerItemView(),
                        CravingShimmerItemView(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
