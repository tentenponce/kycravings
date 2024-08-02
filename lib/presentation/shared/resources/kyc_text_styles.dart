import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';

abstract final class KycTextStyles {
  static TextStyle textStyle1Bold({
    Color color = KycColors.black,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: KycDimens.font7.sp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle textStyle2Reg({
    Color color = KycColors.black,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: KycDimens.font1.sp,
      fontWeight: FontWeight.w400,
    );
  }
}
