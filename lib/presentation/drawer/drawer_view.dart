import 'package:flutter/material.dart';
import 'package:kycravings/presentation/cravings_history/cravings_history_view.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/your_cravings/your_cravings_view.dart';
import 'package:lottie/lottie.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: KycColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.all(KycDimens.space5),
            child: Column(
              children: [
                Lottie.asset(Assets.lottie.logo, height: KycDimens.icon11),
                Text(
                  I18n.of(context).drawerTitle,
                  style: KycTextStyles.textStyle3Bold(color: KycColors.primary),
                ),
                const SizedBox(height: KycDimens.space2),
              ],
            ),
          ),
          ListTile(
            title: Text(
              I18n.of(context).drawerCravings,
              style: KycTextStyles.textStyle4Reg(),
            ),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const YourCravingsView(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              I18n.of(context).drawerHistory,
              style: KycTextStyles.textStyle4Reg(),
            ),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CravingsHistoryView(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              I18n.of(context).drawerAbout,
              style: KycTextStyles.textStyle4Reg(),
            ),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
