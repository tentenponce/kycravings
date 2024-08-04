import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';

mixin ViewCubitMixin<TCubit extends BaseCubit<dynamic>> on StatelessWidget {
  final cubit = GetIt.instance<TCubit>();

  Widget buildView(BuildContext context);

  Object? get arguments => cubit.arguments;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    cubit.arguments = arguments;

    return BlocProvider(
      create: (_) => cubit,
      child: buildView(context),
    );
  }
}
