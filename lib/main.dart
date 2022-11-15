import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_player/screens/root_screens.dart';
import 'navigator/navigation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationCubit>(
      create: (context) => NavigationCubit(),
      child: MaterialApp(
        home: RootScreen(),
      ),
    );
  }
}
