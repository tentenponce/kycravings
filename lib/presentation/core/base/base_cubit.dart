import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  Object? arguments;

  Future<void> init();

  BaseCubit(super.initialState) {
    // ignore: discarded_futures
    init();
  }

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
