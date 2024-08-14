import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:shimmer/shimmer.dart';

class CravingHistoryShimmerItemView extends StatelessWidget {
  const CravingHistoryShimmerItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KycDimens.space3,
        vertical: KycDimens.space5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: KycDimens.textShimmerWidth,
            child: Shimmer.fromColors(
              baseColor: KycColors.lightGray,
              highlightColor: KycColors.shimmerHighlight,
              period: const Duration(milliseconds: 1000),
              child: Container(
                height: KycDimens.font5,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: KycColors.lightGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(KycDimens.radius2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: KycDimens.space3),
          Container(
            margin: const EdgeInsets.only(right: KycDimens.space10),
            child: Shimmer.fromColors(
              baseColor: KycColors.lightGray,
              highlightColor: KycColors.shimmerHighlight,
              period: const Duration(milliseconds: 1000),
              child: Container(
                height: KycDimens.font5,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: KycColors.lightGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(KycDimens.radius2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
