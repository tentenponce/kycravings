import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  Future<void> init();

  BaseCubit(super.initialState) {
    // ignore: discarded_futures
    init();
  }
}
