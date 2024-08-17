import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/add_cravings/add_cravings_view.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/utils/dialog_utils.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/update_cravings/update_cravings_view.dart';
import 'package:kycravings/presentation/your_cravings/cubits/your_cravings_cubit.dart';
import 'package:kycravings/presentation/your_cravings/states/your_cravings_state.dart';
import 'package:kycravings/presentation/your_cravings/subviews/craving_item_view.dart';
import 'package:kycravings/presentation/your_cravings/subviews/craving_shimmer_item_view.dart';

class YourCravingsView extends StatelessWidget with ViewCubitMixin<YourCravingsCubit> {
  const YourCravingsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _YourCravingsView();
  }
}

class _YourCravingsView extends StatefulWidget {
  @override
  State<_YourCravingsView> createState() => _YourCravingsViewState();
}

class _YourCravingsViewState extends State<_YourCravingsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    context.read<YourCravingsCubit>().onInitialLoad = _scrollListener;
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
      unawaited(context.read<YourCravingsCubit>().onScrollBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).yourCravingsTitle,
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
          child: BlocBuilder<YourCravingsCubit, YourCravingsState>(
            builder: (context, state) {
              return !state.isLoading
                  ? Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FixedColumnWidth(KycDimens.space15),
                      },
                      children: state.cravings
                          .map((craving) => CravingItemView.build(
                                context,
                                cravingModel: craving,
                                onItemClick: () async {
                                  final isUpdated = await Navigator.of(context).push(
                                    MaterialPageRoute<bool?>(
                                      builder: (context) => const UpdateCravingsView(),
                                      settings: RouteSettings(arguments: craving),
                                    ),
                                  );

                                  if ((isUpdated ?? false) && context.mounted) {
                                    await context.read<YourCravingsCubit>().getCravings();
                                  }
                                },
                                onDeleteClick: () async => DialogUtils.showConfirmDialog(
                                  context: context,
                                  title: I18n.of(context).yourCravingsDeleteDialogTitle,
                                  message: I18n.of(context).yourCravingsDeleteDialogMessage(craving.name),
                                  onOk: () {
                                    context.read<YourCravingsCubit>().onCravingDelete(craving.id);
                                    Navigator.pop(context);
                                  },
                                ),
                              ))
                          .toList(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isAdded = await Navigator.of(context).push(
            MaterialPageRoute<bool?>(
              builder: (context) => const AddCravingsView(),
            ),
          );

          if ((isAdded ?? false) && context.mounted) {
            await context.read<YourCravingsCubit>().getCravings();
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
