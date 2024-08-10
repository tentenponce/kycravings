import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/drawer/drawer_view.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';
import 'package:kycravings/presentation/home/subviews/predict_button.dart';
import 'package:kycravings/presentation/home/subviews/predicted_craving_view.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_filled.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatelessWidget with ViewCubitMixin<HomeCubit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  HomeView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _HomeView(scaffoldKey: _scaffoldKey);
  }
}

class _HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _HomeView({
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: KycColors.white,
      drawer: const DrawerView(),
      appBar: KycAppBar(
        title: I18n.of(context).appName,
        leadingIcon: const Icon(
          Icons.menu,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => scaffoldKey.currentState?.openDrawer(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => state.predictedCraving != null
                  ? PredictedCravingView(predictedCraving: state.predictedCraving!.name)
                  : const SizedBox(),
            ),
            const SizedBox(height: KycDimens.space6),
            KycButtonFilled(onPressed: context.read<HomeCubit>().chooseCraving, title: 'Craving Satisfied!'),
            const SizedBox(height: KycDimens.space6),
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
