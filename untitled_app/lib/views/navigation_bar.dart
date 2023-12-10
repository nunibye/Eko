import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../utilities/locator.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../utilities/constants.dart' as c;

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    locator<NavBarController>().navigationShell = navigationShell;
    return ChangeNotifierProvider.value(
      value: locator<NavBarController>(),
      builder: (context, child) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected:
              Provider.of<NavBarController>(context, listen: true).goBranch,
        );
      },
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
      bottomNavigationBar: Provider.of<NavBarController>(context, listen: true)
              .enabled
          ? Container(
              height: c.navBarHeight,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              )),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                // c.navBarIconSize:
                //     c.navBarIconSize, //TODO: idk. should these change size based on how big the device is?
                elevation: 16,
                selectedFontSize: 0.0,
                unselectedFontSize: 0.0,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                unselectedItemColor: Theme.of(context).colorScheme.onBackground,
                selectedItemColor: Theme.of(context).colorScheme.onBackground,
                backgroundColor: Theme.of(context).colorScheme.background,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_outlined,
                        size: c.navBarIconSize,
                      ),
                      activeIcon: Icon(
                        Icons.home,
                        size: c.navBarIconSize + c.navBarIconSizeAdder,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.group_outlined,
                        size: c.navBarIconSize,
                      ),
                      activeIcon: Icon(
                        Icons.group,
                        size: c.navBarIconSize + c.navBarIconSizeAdder,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.add,
                        size: c.navBarIconSize,
                      ),
                      activeIcon: Icon(
                        Icons.add,
                        size: c.navBarIconSize + c.navBarIconSizeAdder,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.search,
                        size: c.navBarIconSize,
                      ),
                      activeIcon: Icon(
                        Icons.search,
                        size: c.navBarIconSize + c.navBarIconSizeAdder,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_outline,
                        size: c.navBarIconSize,
                      ),
                      activeIcon: Icon(
                        Icons.person,
                        size: c.navBarIconSize + c.navBarIconSizeAdder,
                      ),
                      label: '')
                ],
                onTap: (index) => onDestinationSelected(index),
              ))
          : null,
    );
  }
}
