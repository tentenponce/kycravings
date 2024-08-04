import 'package:flutter/material.dart';
import 'package:kycravings/presentation/add_cravings/cubits/add_cravings_cubit.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';

class UpdateCravingsView extends StatelessWidget with ViewCubitMixin<AddCravingsCubit> {
  UpdateCravingsView({super.key});

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
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: KycDimens.space11),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: implement delete
                },
                backgroundColor: KycColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
                ),
                child: const Icon(Icons.delete, color: KycColors.red),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                // TODO: implement check
              },
              backgroundColor: KycColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
              ),
              child: const Icon(Icons.check, color: KycColors.white),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
