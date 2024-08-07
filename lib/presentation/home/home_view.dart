import 'package:flutter/material.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/drawer/drawer_view.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/home/subviews/predict_button.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatelessWidget with ViewCubitMixin<HomeCubit> {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: KycColors.white,
      drawer: const DrawerView(),
      appBar: KycAppBar(
        title: I18n.of(context).appName,
        leadingIcon: const Icon(
          Icons.menu,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PredictButton(),
            const SizedBox(height: KycDimens.space6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.lottie.vibrate,
                  width: KycDimens.icon5,
                ),
                Text(
                  I18n.of(context).homeShakeYourPhone,
                  style: KycTextStyles.textStyle5Reg(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
