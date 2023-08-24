import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/views/login.dart';
import 'package:untitled_app/views/root_page.dart';
import 'package:untitled_app/views/sign_up.dart';
import '../views/compose_page.dart';
import '../views/feed_page.dart';
import '../views/search_page.dart';
import '../views/profile_page.dart';
import '../views/edit_profile.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorFeedKey = GlobalKey<NavigatorState>(debugLabel: 'Feed');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'Search');
final _shellNavigatorComposeKey = GlobalKey<NavigatorState>(debugLabel: 'Compose');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'Profile');


final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/',
      builder: (context, state) {
        return const RootPage();
      },),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return const SignUp();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorFeedKey,
          routes: [
            GoRoute(
              path: '/feed',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FeedPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: '/search',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorComposeKey,
          routes: [
            GoRoute(
              path: '/compose',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ComposePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(details: '/profile/edit_profile'),
              ),
              routes: [
                GoRoute(
                  path: 'edit_profile',
                  builder: (context, state) => const EditProfile(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ], 

);





class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: navigationShell,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        iconSize: 25, //TODO: idk. should these change size based on how big the device is?
        elevation: 16,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
        ],
        onTap: onDestinationSelected,
      ),
    );
  }
}
