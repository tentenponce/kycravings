import 'package:flutter/material.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';

class KycTextField extends StatelessWidget {
  const KycTextField({
    super.key,
    String? label,
    int maxLines = 1,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    bool? enabled = true,
    bool readOnly = false,
    GestureTapCallback? onTap,
    TextEditingController? controller,
    Widget? suffixIcon,
  })  : _label = label,
        _maxLines = maxLines,
        _keyboardType = keyboardType,
        _onChanged = onChanged,
        _enabled = enabled,
        _readOnly = readOnly,
        _onTap = onTap,
        _controller = controller,
        _suffixIcon = suffixIcon;

  final String? _label;
  final int _maxLines;
  final TextInputType? _keyboardType;
  final ValueChanged<String>? _onChanged;
  final bool? _enabled;
  final bool _readOnly;
  final GestureTapCallback? _onTap;
  final TextEditingController? _controller;
  final Widget? _suffixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: SizedBox(
        height: _maxLines > 1 ? null : KycDimens.textFieldHeight,
        child: TextField(
          controller: _controller,
          enabled: _enabled,
          readOnly: _readOnly,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(KycDimens.space2),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: KycColors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: KycColors.primary),
            ),
            border: const OutlineInputBorder(),
            labelText: _label,
            floatingLabelStyle: const TextStyle(color: KycColors.primary),
            alignLabelWithHint: true,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: _suffixIcon,
          ),
          style: const TextStyle(
            fontSize: KycDimens.font3,
          ),
          cursorColor: KycColors.primary,
          keyboardType: _keyboardType ?? TextInputType.multiline,
          maxLines: _maxLines,
          onChanged: _onChanged,
        ),
      ),
    );
  }
}
