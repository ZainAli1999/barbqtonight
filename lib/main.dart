import 'package:barbqtonight/core/cubits/app_user_cubit.dart';
import 'package:barbqtonight/core/route_structure/go_router.dart';
import 'package:barbqtonight/core/theme/bloc/theme_bloc.dart';
import 'package:barbqtonight/core/theme/bloc/theme_state.dart';
import 'package:barbqtonight/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:barbqtonight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:barbqtonight/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();

  final appUserCubit = serviceLocator<AppUserCubit>();
  final authLocalDataSource = serviceLocator<AuthLocalDataSource>();

  final user = authLocalDataSource.getCachedUser();

  if (user != null) {
    appUserCubit.updateUser(user);
  }
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>()..add(FetchAllUsers()),
        ),
        BlocProvider(create: (_) => appUserCubit),
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
