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
import 'package:kycravings/presentation/shared/widgets/kyc_add_category_dialog.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_app_bar.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_tag.dart';
import 'package:kycravings/presentation/shared/widgets/kyc_text_field.dart';

class AddCravingsView extends StatelessWidget with ViewCubitMixin<AddCravingsCubit> {
  const AddCravingsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _AddCravingsView();
  }
}

class _AddCravingsView extends StatelessWidget {
  final TextEditingController _cravingController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KycColors.white,
      appBar: KycAppBar(
        title: I18n.of(context).addCravingsTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: KycColors.white,
        ),
        onLeadingIconClick: () => Navigator.of(context).pop(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await context.read<AddCravingsCubit>().addCraving(_cravingController.text) && context.mounted) {
            Navigator.pop(context, true);
          }
        },
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
                controller: _cravingController,
                onChanged: context.read<AddCravingsCubit>().onCravingChanged,
              ),
              const SizedBox(height: KycDimens.space3),
              BlocBuilder<AddCravingsCubit, AddCravingsState>(builder: (context, state) {
                return Text(
                  switch (state.cravingError) {
                    CravingError.empty => I18n.of(context).addCravingsErrorEmpty,
                    CravingError.duplicate => I18n.of(context).addCravingsErrorDuplicate(_cravingController.text),
                    CravingError.none => '',
                  },
                  style: KycTextStyles.textStyle6Reg().copyWith(color: KycColors.red),
                );
              }),
              const SizedBox(height: KycDimens.space7),
              Text(
                I18n.of(context).addCravingsCategoryListTitle,
                style: KycTextStyles.textStyle6Reg(),
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
                          isSelected: category.isSelected ?? false,
                          onPressed: () => context.read<AddCravingsCubit>().onCategoryClick(category.id),
                          onLongPress: () async => DialogUtils.showConfirmDialog(
                            context: context,
                            title: I18n.of(context).addCravingsCategoryDeleteDialogTitle,
                            message: I18n.of(context).addCravingsCategoryDeleteDialogMessage(category.name),
                            onOk: () {
                              context.read<AddCravingsCubit>().onLongPressCategory(category.id);
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
                        context.read<AddCravingsCubit>().onAddCategory();
                        await _showTextInputDialog(context);
                      },
                    )),
                ),
              ),
              const SizedBox(height: KycDimens.space5),
              Text(
                I18n.of(context).addCravingsCategoryListMessage,
                style: KycTextStyles.textStyle6Reg(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    _categoryController.text = '';
    return KycAddCategoryDialog.show(
      context: context,
      onOk: (value) async {
        if (await context.read<AddCravingsCubit>().addCategory(value)) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      categoryController: _categoryController,
      onTextChanged: context.read<AddCravingsCubit>().onCategoryChanged,
      errorMessage: BlocBuilder<AddCravingsCubit, AddCravingsState>(
        bloc: context.read<AddCravingsCubit>(),
        buildWhen: (previous, current) => previous.categoryError != current.categoryError,
        builder: (context, state) {
          return Text(
            switch (state.categoryError) {
              CategoryError.empty => I18n.of(context).addCravingsCategoryDialogErrorEmpty,
              CategoryError.duplicate =>
                I18n.of(context).addCravingsCategoryDialogErrorDuplicate(_categoryController.text),
              CategoryError.none => '',
            },
            style: KycTextStyles.textStyle6Reg().copyWith(color: KycColors.red),
          );
        },
      ),
    );
  }
}
