import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/presentation/home/home_view.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';

abstract interface class NavigationMapper {
  Widget getRoute(ViewRoute viewRoute);
}

@LazySingleton(as: NavigationMapper)
class NavigationMapperImpl implements NavigationMapper {
  @override
  Widget getRoute(ViewRoute viewRoute) {
    switch (viewRoute) {
      case ViewRoute.home:
        return HomeView();
    }
  }
}
