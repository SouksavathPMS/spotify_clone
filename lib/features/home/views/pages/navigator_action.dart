import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/features/home/views/widgets/music_slab.dart';

class NavigatorAction extends ConsumerWidget {
  const NavigatorAction({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              navigationShell.currentIndex == 0
                  ? "assets/images/home_filled.png"
                  : "assets/images/home_unfilled.png",
              color: navigationShell.currentIndex == 0
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/library.png",
              color: navigationShell.currentIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}

// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final String location = GoRouterState.of(context).uri.toString();

//     return ;
//   }

//   int _getSelectedIndex(String location) {
//     if (location == '/uploadSong') {
//       return 0;
//     } else if (location == '/libraryPage') {
//       return 1;
//     }
//     return 0;
//   }
// }
