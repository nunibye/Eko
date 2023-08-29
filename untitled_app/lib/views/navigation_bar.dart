import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../utilities/locator.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;
//TODO not MVVM
  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
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
    return ChangeNotifierProvider.value(
      
        value: locator<NavBarController>(),
        builder: (context, child) {
          return Scaffold(
            body: body,
            bottomNavigationBar: Provider.of<NavBarController>(context, listen: true)
                                .enabled
                ? 
                 BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: selectedIndex,
                    iconSize:
                        25, //TODO: idk. should these change size based on how big the device is?
                    elevation: 16,
                    showUnselectedLabels: false,
                    showSelectedLabels: false,
                    unselectedItemColor:
                        Theme.of(context).colorScheme.onPrimary,
                    selectedItemColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.search), label: 'search'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.add), label: 'add'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'profile')
                    ],
                    onTap: onDestinationSelected,
                  ): null,
          );
        });
  }
}
