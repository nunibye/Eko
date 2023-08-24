// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../views/search_page.dart';
// import '../views/profile_page.dart';
// import '../views/edit_profile.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
// final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');

// final goRouter = GoRouter(
//   initialLocation: '/feed',
//   // * Passing a navigatorKey causes an issue on hot reload:
//   // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
//   // * However it's still necessary otherwise the navigator pops back to
//   // * root on hot reload
//   navigatorKey: _rootNavigatorKey,
//   debugLogDiagnostics: true,
//   routes: [
//     // Stateful navigation based on:
//     // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
//     StatefulShellRoute.indexedStack(
//       builder: (context, state, navigationShell) {
//         return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
//       },
//       branches: [
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorAKey,
//           routes: [
//             GoRoute(
//               path: '/feed',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: SearchPage(),
//               ),
//             ),
//           ],
//         ),
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorBKey,
//           routes: [
//             // Shopping Cart
//             GoRoute(
//               path: '/profile',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: ProfilePage(detailsPath: '/profile/edit_profile'),
//               ),
//               routes: [
//                 GoRoute(
//                   path: 'details',
//                   builder: (context, state) => const EditProfile(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// );

// class ScaffoldWithNestedNavigation extends StatelessWidget {
//   const ScaffoldWithNestedNavigation({
//     Key? key,
//     required this.navigationShell,
//   }) : super(
//             key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
//   final StatefulNavigationShell navigationShell;

//   void _goBranch(int index) {
//     navigationShell.goBranch(
//       index,
//       // A common pattern when using bottom navigation bars is to support
//       // navigating to the initial location when tapping the item that is
//       // already active. This example demonstrates how to support this behavior,
//       // using the initialLocation parameter of goBranch.
//       initialLocation: index == navigationShell.currentIndex,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWithNavigationBar(
//       body: navigationShell,
//       selectedIndex: navigationShell.currentIndex,
//       onDestinationSelected: _goBranch,
//     );
//   }
// }

// class ScaffoldWithNavigationBar extends StatelessWidget {
//   const ScaffoldWithNavigationBar({
//     super.key,
//     required this.body,
//     required this.selectedIndex,
//     required this.onDestinationSelected,
//   });
//   final Widget body;
//   final int selectedIndex;
//   final ValueChanged<int> onDestinationSelected;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: body,
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: selectedIndex,
//         destinations: const [
//           NavigationDestination(label: 'Section A', icon: Icon(Icons.home)),
//           NavigationDestination(label: 'Section B', icon: Icon(Icons.settings)),
//         ],
//         onDestinationSelected: onDestinationSelected,
//       ),
//     );
//   }
// }
