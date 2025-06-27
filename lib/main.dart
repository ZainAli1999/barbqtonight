import 'package:barbqtonight/core/current_user_bloc/current_user_bloc.dart';
import 'package:barbqtonight/core/current_user_bloc/current_user_event.dart';
import 'package:barbqtonight/core/route_structure/go_router.dart';
import 'package:barbqtonight/core/theme/bloc/theme_bloc.dart';
import 'package:barbqtonight/core/theme/bloc/theme_state.dart';
import 'package:barbqtonight/features/auth/bloc/auth_bloc.dart';
import 'package:barbqtonight/features/auth/repository/auth_local_repository.dart';
import 'package:barbqtonight/features/auth/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authLocalRepository = AuthLocalRepository();
  await authLocalRepository.init();
  final user = authLocalRepository.getUser();
  final currentUserBloc = CurrentUserBloc(authLocalRepository);
  if (user != null) {
    currentUserBloc.add(AddUserEvent(user));
  }
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
          create:
              (_) => AuthBloc(
                currentUserBloc: currentUserBloc,
                authRepository: AuthRepository(),
                authLocalRepository: authLocalRepository,
              ),
        ),
        BlocProvider<CurrentUserBloc>(create: (_) => currentUserBloc),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routes = RouteName();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Bar BQ Tonight',
          theme: state.themeData,
          routerConfig: _routes.myrouter,
          builder:
              (context, widget) => ResponsiveBreakpoints.builder(
                child: Builder(
                  builder: (context) {
                    return ResponsiveScaledBox(
                      width:
                          ResponsiveValue<double?>(
                            context,
                            defaultValue: null,
                            conditionalValues: [
                              const Condition.equals(name: PHONE, value: 450),
                            ],
                          ).value,
                      child: ClampingScrollWrapper.builder(context, widget!),
                    );
                  },
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: PHONE),
                  const Breakpoint(start: 451, end: 750, name: MOBILE),
                  const Breakpoint(start: 751, end: 1080, name: TABLET),
                  const Breakpoint(
                    start: 1081,
                    end: double.infinity,
                    name: DESKTOP,
                  ),
                ],
              ),
        );
      },
    );
  }
}
