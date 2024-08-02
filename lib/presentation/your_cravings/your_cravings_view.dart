import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/your_cravings/subviews/craving_item_view.dart';

class YourCravingsView extends StatelessWidget {
  const YourCravingsView({super.key});

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
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FixedColumnWidth(KycDimens.space14),
          },
          children: [
            // list of your cravings
            CravingItemView.build(
              context,
              cravingName: 'Sinigang',
              categories: ['Sabaw', 'Maasim', 'Pork'],
            ),
            CravingItemView.build(
              context,
              cravingName: 'Nilaga',
              categories: ['Sabaw', 'Pork', 'Maalat'],
            ),
          ],
        ),
      ),
    );
  }
}
