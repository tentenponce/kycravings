import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/presentation/home/home_view.dart';

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

  NavigationUtilsImpl(this.navigatorKey);

  @override
  Future<T?>? push<T>(ViewRoute viewRoute, {Object? arguments}) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute<T>(
        builder: (context) => _getRoute(viewRoute),
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  Widget _getRoute(ViewRoute viewRoute) {
    switch (viewRoute) {
      case ViewRoute.home:
        return HomeView();
    }
  }

  @override
  Future<T?>? pushReplacement<T>(ViewRoute viewRoute, {Object? arguments}) {
    return navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute<T>(
        builder: (context) => _getRoute(viewRoute),
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }
}
