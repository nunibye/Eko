import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/views/login.dart';
//import 'package:untitled_app/views/root_page.dart';
import 'package:untitled_app/views/sign_up.dart';
import 'package:untitled_app/views/user_settings.dart';
import '../views/compose_page.dart';
import '../views/feed_page.dart';
import '../views/search_page.dart';
import '../views/profile_page.dart';
import '../views/edit_profile.dart';
import 'router_notifier.dart';
import '../views/navigation_bar.dart';
import '../models/post_handler.dart';
import '../views/other_profile.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorFeedKey = GlobalKey<NavigatorState>(debugLabel: 'Feed');
final _shellNavigatorSearchKey =
    GlobalKey<NavigatorState>(debugLabel: 'Search');
final _shellNavigatorComposeKey =
    GlobalKey<NavigatorState>(debugLabel: 'Compose');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'Profile');
final routerNotifier = RouterNotifier();
final goRouter = GoRouter(
  refreshListenable: routerNotifier,
  redirect: routerNotifier.redirect,
  initialLocation: '/login',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) {
    //     return const RootPage();
    //   },
    // ),
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
              name: 'feed',
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
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: 'sub_profile',
                    builder: (context, state) {
                      Post? post = state.extra as Post?;
                      return OtherProfile(post: post);
                    },
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorComposeKey,
          routes: [
            GoRoute(
              path: '/compose',
              name: 'compose',
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
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(),
              ),
              routes: [
                GoRoute(
                  path: 'edit_profile',
                  name: 'edit_profile',
                  builder: (context, state) => const EditProfile(),
                ),
                GoRoute(
                  path: 'user_settings',
                  name: 'user_settings',
                  builder: (context, state) => const UserSettings(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
