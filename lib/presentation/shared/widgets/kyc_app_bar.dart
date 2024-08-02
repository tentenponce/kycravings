import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';

class KycAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KycAppBar({
    super.key,
    required this.title,
    required this.onLeadingIconClick,
    required this.leadingIcon,
  });

  final String title;
  final VoidCallback onLeadingIconClick;
  final Widget leadingIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: KycColors.primary,
      elevation: 6,
      shadowColor: KycColors.black.withOpacity(0.8),
      leading: IconButton(
        icon: leadingIcon,
        onPressed: onLeadingIconClick,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: KycTextStyles.textStyle1Bold(color: KycColors.white),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + KycDimens.space6);
}
