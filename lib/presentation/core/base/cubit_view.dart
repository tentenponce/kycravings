import 'package:flutter/widgets.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';

abstract interface class CubitView<TCubit extends BaseCubit<dynamic>> {
  Widget build(BuildContext context);

  Widget buildView(BuildContext context);

  TCubit onCreateCubit(BuildContext context);
}
