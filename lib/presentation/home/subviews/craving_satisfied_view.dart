import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kycravings/domain/core/utils/random_utils.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';
import 'package:kycravings/presentation/home/subviews/craving_satisfied_dialog.dart';
import 'package:kycravings/presentation/shared/assets/assets.gen.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:lottie/lottie.dart';

class CravingSatisfiedView extends StatefulWidget {
  final GlobalKey satisfiedKey;
  const CravingSatisfiedView({
    required this.satisfiedKey,
    super.key,
  });

  @override
  State<CravingSatisfiedView> createState() => _CravingSatisfiedViewState();
}

class _CravingSatisfiedViewState extends State<CravingSatisfiedView> with TickerProviderStateMixin {
  late AnimationController _checkController;
  double _cravingSatisfiedSize = KycDimens.icon10;
  TextStyle _cravingSatisfiedTextSize = KycTextStyles.textStyle5Bold();
  bool _isSatisfied = false;
  int _cravingImageIndex = 0;

  // TODO: support for multiple images
  final cravingImages = [
    Assets.images.lipbite.image(),
  ];

  @override
  void initState() {
    super.initState();

    _cravingImageIndex = GetIt.instance.get<RandomUtils>().randomizeInt(0, cravingImages.length - 1);
    _checkController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Expanded(
        flex: state.predictedCraving != null ? 2 : 0,
        child: SizedBox(
          height: state.predictedCraving != null ? null : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: state.predictedCraving != null ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: KycDimens.space6),
                GestureDetector(
                  onTap: _onCravingSatisfied,
                  onTapDown: (_) => setState(() {
                    if (_cravingSatisfiedSize != 0) {
                      _cravingSatisfiedSize = KycDimens.icon9;
                      _cravingSatisfiedTextSize = KycTextStyles.textStyle3Bold();
                    }
                  }),
                  onTapUp: (_) => _onPressedCancel(),
                  onTapCancel: _onPressedCancel,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        key: widget.satisfiedKey,
                        duration: const Duration(milliseconds: 150),
                        width: _cravingSatisfiedSize,
                        height: _cravingSatisfiedSize,
                        child: cravingImages[_cravingImageIndex],
                      ),
                      if (_isSatisfied)
                        Lottie.asset(
                          controller: _checkController,
                          Assets.lottie.check,
                          repeat: false,
                          onLoaded: (composition) async {
                            _checkController
                              ..reset()
                              ..duration = const Duration(seconds: 1)
                              ..forward()
                              ..addStatusListener((status) async {
                                if (status == AnimationStatus.completed) {
                                  await context.read<HomeCubit>().chooseCraving();
                                  await Future<void>.delayed(const Duration(milliseconds: 300));
                                  _resetState();

                                  // reset controller to avoid duplicate chosen craving
                                  _checkController.dispose();
                                  _checkController = AnimationController(vsync: this);
                                }
                              });
                          },
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: KycDimens.space4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: _cravingSatisfiedTextSize,
                  child: Text(I18n.of(context).homeCravingSatisfied),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _onCravingSatisfied() async {
    if (!context.read<HomeCubit>().isDoNotShowCravingSatisfiedDialogAgain) {
      final result = await showDialog<Map<String, dynamic>>(
          context: context, builder: (context) => const CravingSatisfiedDialog());

      if (result != null) {
        final isOkay = result[CravingSatisfiedDialog.isOkay];
        final isDontShowAgain = result[CravingSatisfiedDialog.isDontShowEnabled];

        if (mounted) {
          unawaited(
            context.read<HomeCubit>().doNotShowCravingSatisfiedDialogAgain(isDontShowAgain: isDontShowAgain == true),
          );
        }

        if (isOkay == true) {
          _cravingsSatisfied();
        }
      }
    } else {
      _cravingsSatisfied();
    }
  }

  void _cravingsSatisfied() {
    setState(() {
      _isSatisfied = true;
      _cravingSatisfiedSize = 0;
      _cravingSatisfiedTextSize = KycTextStyles.textStyle3Bold();
    });
  }

  void _onPressedCancel() {
    if (_cravingSatisfiedSize != 0) {
      setState(() {
        _cravingSatisfiedSize = KycDimens.icon10;
        _cravingSatisfiedTextSize = KycTextStyles.textStyle5Bold();
      });
    }
  }

  void _resetState() {
    setState(() {
      _cravingImageIndex = GetIt.instance.get<RandomUtils>().randomizeInt(0, cravingImages.length - 1);
      _isSatisfied = false;
      _cravingSatisfiedSize = KycDimens.icon10;
      _cravingSatisfiedTextSize = KycTextStyles.textStyle5Bold();
    });
  }
}
