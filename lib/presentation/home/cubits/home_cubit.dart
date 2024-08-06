import 'package:injectable/injectable.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit() : super(const HomeState.on());

  @override
  Future<void> init() async {}
}
