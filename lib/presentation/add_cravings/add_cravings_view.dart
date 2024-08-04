import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kycravings/presentation/add_cravings/cubits/add_cravings_cubit.dart';
import 'package:kycravings/presentation/add_cravings/states/add_cravings_state.dart';
import 'package:kycravings/presentation/core/base/view_cubit_mixin.dart';
import 'package:kycravings/presentation/shared/localization/generated/l10n.dart';
import 'package:kycravings/presentation/shared/resources/kyc_colors.dart';
import 'package:kycravings/presentation/shared/resources/kyc_dimens.dart';
import 'package:kycravings/presentation/shared/resources/kyc_text_styles.dart';
import 'package:kycravings/presentation/shared/utils/dialog_utils.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_text_field.dart';

class AddCravingsView extends StatelessWidget with ViewCubitMixin<AddCravingsCubit> {
  AddCravingsView({super.key});

  final TextEditingController _categoryController = TextEditingController();

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
                buildWhen: (previous, current) => previous.categories != current.categories,
                builder: (context, state) => Wrap(
                  spacing: KycDimens.space2,
                  runSpacing: KycDimens.space2,
                  children: state.categories
                      .map(
                        (category) => KycTag(
                          label: category.name,
                          isSelected: false,
                          onLongPress: () async => DialogUtils.showConfirmDialog(
                            context: context,
                            title: I18n.of(context).addCravingsCategoryDeleteDialogTitle,
                            message: I18n.of(context).addCravingsCategoryDeleteDialogMessage(category.name),
                            onOk: () {
                              cubit.onLongPressCategory(category.id);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                      .toList()
                    ..add(KycTag(
                      label: I18n.of(context).addCravingsCategoryButton,
                      isSelected: false,
                      onPressed: () async {
                        cubit.onAddCategory();
                        await _showTextInputDialog(context);
                      },
                    )),
                ),
              ),
              const SizedBox(height: KycDimens.space5),
              Text(
                I18n.of(context).addCravingsCategoryListMessage,
                style: KycTextStyles.textStyle5Reg(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    _categoryController.text = '';
    return DialogUtils.showTextInputDialog(
      context: context,
      onOk: (value) async {
        if (await cubit.addCategory(value)) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      title: I18n.of(context).addCravingsCategoryDialogTitle,
      textEditingController: _categoryController,
      onTextChanged: cubit.onCategoryChanged,
      errorMessage: BlocBuilder<AddCravingsCubit, AddCravingsState>(
        buildWhen: (previous, current) => previous.categoryError != current.categoryError,
        bloc: cubit,
        builder: (context, state) {
          return Text(
            switch (state.categoryError) {
              CategoryError.empty => I18n.of(context).addCravingsCategoryDialogErrorEmpty,
              CategoryError.duplicate =>
                I18n.of(context).addCravingsCategoryDialogErrorDuplicate(_categoryController.text),
              CategoryError.none => '',
            },
            style: KycTextStyles.textStyle5Reg().copyWith(color: KycColors.red),
          );
        },
      ),
      ok: I18n.of(context).genericAdd,
    );
  }
}
