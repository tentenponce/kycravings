import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';

mixin ViewCubitMixin<TCubit extends BaseCubit<dynamic>> on StatelessWidget {
  Widget buildView(BuildContext context);

  Object? arguments(BuildContext context) {
    return ModalRoute.of(context)!.settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final cubit = GetIt.instance<TCubit>();
    cubit.arguments = arguments;

    return BlocProvider(
      create: (_) => cubit,
      child: buildView(context),
    );
  }
}
