import 'dart:async';
import 'package:barbqtonight/core/current_user_bloc/current_user_bloc.dart';
import 'package:barbqtonight/core/current_user_bloc/current_user_state.dart';
import 'package:barbqtonight/core/route_structure/go_navigator.dart';
import 'package:barbqtonight/core/route_structure/go_router.dart';
import 'package:barbqtonight/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final state = context.read<CurrentUserBloc>().state;

      if (state is UserInitialState) {
        Go.namedReplace(context, RouteName.loginPage);
      } else if (state is UserAddedState) {
        Go.namedReplace(context, RouteName.homePage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Constants.appLogo, height: 250)],
            ),
          ),
        ),
      ),
    );
  }
}
