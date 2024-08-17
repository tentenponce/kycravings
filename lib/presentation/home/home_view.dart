import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/drawer/drawer_view.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';
import 'package:kycravings/presentation/home/subviews/craving_satisfied_view.dart';
import 'package:kycravings/presentation/home/subviews/predict_button.dart';
import 'package:kycravings/presentation/home/subviews/predicted_craving_view.dart';
import 'package:kycravings/presentation/home/subviews/tutorial_details_view.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shake/shake.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeView extends StatelessWidget with ViewCubitMixin<HomeCubit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  HomeView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _HomeView(scaffoldKey: _scaffoldKey);
  }
}

class _HomeView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _HomeView({
    required this.scaffoldKey,
  });

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final GlobalKey _predictKey = GlobalKey();
  final GlobalKey _satisfiedKey = GlobalKey();
  final GlobalKey _drawerKey = GlobalKey();

  ShakeDetector? _detector;

  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().showTutorial = _showTutorial;

    _detector = ShakeDetector.autoStart(onPhoneShake: () {
      unawaited(context.read<HomeCubit>().predict(isShake: true));
    });
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }

  void _showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: HomeAppTutorial.predict,
          keyTarget: _predictKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: TutorialDetailsView(
                title: I18n.of(context).homeTutorialPredictTitle,
                message: I18n.of(context).homeTutorialPredictMessage,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: HomeAppTutorial.satisfied,
          keyTarget: _satisfiedKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: TutorialDetailsView(
                title: I18n.of(context).homeTutorialSatisfiedTitle,
                message: I18n.of(context).homeTutorialSatisfiedMessage,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: HomeAppTutorial.drawer,
          keyTarget: _drawerKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: TutorialDetailsView(
                title: I18n.of(context).homeTutorialDrawerTitle,
                message: I18n.of(context).homeTutorialDrawerMessage,
              ),
            ),
          ],
        ),
      ],
      hideSkip: true,
      colorShadow: KycColors.secondary,
      onClickTarget: (target) async {
        await context.read<HomeCubit>().onNextTutorial(target.identify as HomeAppTutorial);
      },
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: KycColors.white,
      drawer: const DrawerView(),
      appBar: KycAppBar(
        title: I18n.of(context).appName,
        leadingIcon: Icon(
          key: _drawerKey,
          Icons.menu,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => widget.scaffoldKey.currentState?.openDrawer(),
      ),
      body: AnimatedSize(
        duration: const Duration(milliseconds: 1000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => Expanded(
                flex: state.predictedCraving != null ? 1 : 0,
                child: const SizedBox(),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => SizedBox(
                height: state.predictedCraving != null ? null : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state.predictedCraving != null ? 1 : 0,
                  child: PredictedCravingView(
                    predictedCraving: state.predictedCraving ?? CravingModel.empty,
                    isSwipePredicting: state.isSwipePredicting,
                  ),
                ),
              ),
            ),
            CravingSatisfiedView(satisfiedKey: _satisfiedKey),
            const SizedBox(height: KycDimens.space6),
            PredictButton(key: _predictKey),
            const SizedBox(height: KycDimens.space6),
            BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              return state.predictedCraving == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.lottie.vibrate,
                          width: KycDimens.icon5,
                        ),
                        Text(
                          I18n.of(context).homeShakeYourPhone,
                          style: KycTextStyles.textStyle6Reg(),
                        )
                      ],
                    )
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
