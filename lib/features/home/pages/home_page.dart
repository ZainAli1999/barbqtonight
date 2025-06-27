import 'package:barbqtonight/core/current_user_bloc/current_user_bloc.dart';
import 'package:barbqtonight/core/current_user_bloc/current_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Scaffold(appBar: _buildPageHeader(state));
      },
    );
  }

  AppBar _buildPageHeader(CurrentUserState state) {
    if (state is UserAddedState) {
      return AppBar(
        title: Text("${state.user.firstName} ${state.user.lastName}"),
      );
    }
    return AppBar();
  }
}
