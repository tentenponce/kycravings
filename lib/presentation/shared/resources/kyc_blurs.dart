import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';

abstract final class KycBlurs {
  static List<BoxShadow> standardBlur = [
    BoxShadow(
      color: KycColors.black.withOpacity(0.2),
      blurRadius: 5,
      offset: const Offset(0, 5),
    )
  ];
}
