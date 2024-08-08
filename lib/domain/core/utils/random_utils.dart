import 'dart:math';

import 'package:injectable/injectable.dart';

abstract interface class RandomUtils {
  int randomizeInt(int from, int to);
}

@LazySingleton(as: RandomUtils)
class RandomUtilsImpl implements RandomUtils {
  RandomUtilsImpl();

  @override
  int randomizeInt(int from, int to) {
    final random = Random();

    return random.nextInt(to - from + 1) + from;
  }
}
