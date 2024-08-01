import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kycravings/presentation/app/subviews/predict_button.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: KycColors.primary),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: KycColors.white,
          appBar: KycAppBar(
            title: 'KYCravings',
            leadingIcon: const Icon(
              Icons.menu,
              color: KycColors.white,
            ),
            onLeadingIconClick: () {
              // TODO: show drawer
            },
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PredictButton(),
                SizedBox(height: KycDimens.space6),
                Text(
                  'or try shaking your phone!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
