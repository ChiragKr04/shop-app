import 'package:flutter/material.dart';

class PageTransition<T> extends MaterialPageRoute<T> {
  PageTransition({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// class EnterExitRoute extends PageRouteBuilder {
//   final Widget enterPage;
//   final Widget exitPage;
//   EnterExitRoute({this.exitPage, this.enterPage})
//       : super(
//           pageBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) =>
//               enterPage,
//           transitionsBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child,
//           ) =>
//               Stack(
//             children: <Widget>[
//               SlideTransition(
//                 position: new Tween<Offset>(
//                   begin: const Offset(0.0, 0.0),
//                   end: const Offset(-1.0, 0.0),
//                 ).animate(animation),
//                 child: exitPage,
//               ),
//               SlideTransition(
//                 position: new Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: enterPage,
//               )
//             ],
//           ),
//         );
// }
