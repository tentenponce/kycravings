import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';

mixin ViewCubitMixin<TCubit extends BaseCubit<dynamic>> on StatelessWidget {
  final cubit = GetIt.instance<TCubit>();

  Widget buildView(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: buildView(context),
    );
  }
}
