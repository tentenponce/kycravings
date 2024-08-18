import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/presentation/shared/utils/navigation_mapper.dart';

enum ViewRoute {
  home,
}

abstract interface class NavigationUtils {
  Future<T?>? push<T>(ViewRoute viewRoute, {Object? arguments});
  Future<T?>? pushReplacement<T>(ViewRoute viewRoute, {Object? arguments});
}

@LazySingleton(as: NavigationUtils)
class NavigationUtilsImpl implements NavigationUtils {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationMapper _navigationMapper;

  NavigationUtilsImpl(
    this.navigatorKey,
    this._navigationMapper,
  );

  @override
  Future<T?>? push<T>(ViewRoute viewRoute, {Object? arguments}) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute<T>(
        builder: (context) => _navigationMapper.getRoute(viewRoute),
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  @override
  Future<T?>? pushReplacement<T>(ViewRoute viewRoute, {Object? arguments}) {
    return navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute<T>(
        builder: (context) => _navigationMapper.getRoute(viewRoute),
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }
}
