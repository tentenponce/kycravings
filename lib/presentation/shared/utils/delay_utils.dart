import 'package:injectable/injectable.dart';

abstract interface class DelayUtils {
  Future<void> delay(Duration duration);
}

@LazySingleton(as: DelayUtils)
class DelayUtilsImpl implements DelayUtils {
  @override
  Future<void> delay(Duration duration) {
    return Future.delayed(duration);
  }
}
