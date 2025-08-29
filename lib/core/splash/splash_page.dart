import 'dart:async';
import 'package:barbqtonight/core/cubits/app_user_cubit.dart';
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
    Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      Go.namedReplace(context, RouteName.homePage);
    } else {
      Go.namedReplace(context, RouteName.loginPage);
    }
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
