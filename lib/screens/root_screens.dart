import 'package:flutter_firebase_player/navigator/navigation_cubit.dart';
import 'package:flutter_firebase_player/screens/music/music.dart';
import 'package:flutter_firebase_player/screens/my_music_collection/my_music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 34, 34, 34),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
            unselectedItemColor: Color.fromARGB(255, 209, 51, 237),
            selectedIconTheme: IconThemeData(color: Colors.pink, size: 40),
            selectedItemColor: Colors.pink,
            backgroundColor: Color.fromRGBO(18, 18, 18, 18),
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.home);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.settings);
              }
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navbarItem == NavbarItem.home) {
          return Musics();
        } else if (state.navbarItem == NavbarItem.settings) {
          return My_Musics();
        }
        return Container();
      }),
    );
  }
}
