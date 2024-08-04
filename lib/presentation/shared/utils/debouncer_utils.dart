import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';

abstract interface class DebouncerUtil {
  void setMilliseconds(int value);

  void run(VoidCallback action);

  void cancel();
}

@Injectable(as: DebouncerUtil)
class DebouncerUtilImpl implements DebouncerUtil {
  Timer? _timer;
  int _milliseconds = 1000;

  @override
  void setMilliseconds(int value) {
    _milliseconds = value;
  }

  @override
  void run(VoidCallback action) {
    cancel();
    _timer = Timer(Duration(milliseconds: _milliseconds), action);
  }

  @override
  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
