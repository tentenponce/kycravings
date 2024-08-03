import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/add_cravings/cubits/add_cravings_cubit.dart';
import 'package:kycravings/presentation/add_cravings/states/add_cravings_state.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_filled.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_button_outlined.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_text_field.dart';

class AddCravingsView extends StatelessWidget with ViewCubitMixin<AddCravingsCubit> {
  AddCravingsView({super.key});

  final _textFieldController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).yourCravingsTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => Navigator.of(context).pop(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cubit.add,
        backgroundColor: KycColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KycDimens.radiusCircle),
        ),
        child: const Icon(Icons.check, color: KycColors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: KycDimens.space13,
            horizontal: KycDimens.space10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KycTextField(
                label: I18n.of(context).addCravingsHint,
              ),
              const SizedBox(height: KycDimens.space10),
              Text(
                I18n.of(context).addCravingsCategoryListTitle,
                style: KycTextStyles.textStyle5Reg(),
              ),
              const SizedBox(height: KycDimens.space5),
              BlocBuilder<AddCravingsCubit, AddCravingsState>(
                builder: (context, state) => Wrap(
                  spacing: KycDimens.space2,
                  runSpacing: KycDimens.space2,
                  children: state.categories.map((category) => KycTag(label: category.name, isSelected: false)).toList()
                    ..add(KycTag(
                      label: I18n.of(context).addCravingsCategoryButton,
                      isSelected: false,
                      onPressed: () async {
                        await _showTextInputDialog(context);
                      },
                    )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: KycColors.white,
            title: Text(
              I18n.of(context).addCravingsCategoryDialogTitle,
              style: KycTextStyles.textStyle3Bold(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KycTextField(
                  controller: _textFieldController,
                  onChanged: cubit.onCategoryChanged,
                ),
                const SizedBox(height: KycDimens.space3),
                BlocBuilder<AddCravingsCubit, AddCravingsState>(
                  bloc: cubit,
                  builder: (context, state) {
                    return state.showErrorEmptyCategory
                        ? Text(
                            I18n.of(context).addCravingsCategoryDialogErrorEmpty,
                            style: KycTextStyles.textStyle5Reg().copyWith(color: KycColors.red),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
            actions: <Widget>[
              KycButtonOutlined(
                title: I18n.of(context).genericCancel,
                onPressed: () => Navigator.pop(context),
                isSmall: true,
              ),
              KycButtonFilled(
                title: I18n.of(context).genericAdd,
                onPressed: () async {
                  if (await cubit.addCategory(_textFieldController.text)) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                isSmall: true,
              ),
            ],
          );
        });
  }
}
