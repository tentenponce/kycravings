import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/your_cravings/cubits/your_cravings_cubit.dart';
import 'package:kycravings/presentation/your_cravings/states/your_cravings_state.dart';
import 'package:kycravings/presentation/your_cravings/subviews/craving_item_view.dart';

class YourCravingsView extends StatelessWidget with ViewCubitMixin<YourCravingsCubit> {
  YourCravingsView({super.key});

  @override
  Widget buildView(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your craving
        },
        backgroundColor: KycColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
        ),
        child: const Icon(Icons.add, color: KycColors.white),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<YourCravingsCubit, YourCravingsState>(
          builder: (context, state) {
            return Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FixedColumnWidth(KycDimens.space14),
              },
              children: state.cravings
                  .map((craving) => CravingItemView.build(
                        context,
                        cravingName: craving.name,
                        categories: craving.categories.map((category) => category.name),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
