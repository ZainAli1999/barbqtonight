import 'package:barbqtonight/core/common_widgets/snack_bar.dart';
import 'package:barbqtonight/core/cubits/app_user_cubit.dart';
import 'package:barbqtonight/core/extensions/spacing_extension.dart';
import 'package:barbqtonight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshUsers() async {
    context.read<AuthBloc>().add(FetchAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        return Scaffold(appBar: _buildAppBar(state), body: _buildBody());
      },
    );
  }

  Widget _buildBody() {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthFailure,
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is UsersDisplaySuccess) {
          final users = state.users;

          if (users.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshUsers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("No users found.")),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshUsers,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) => 10.kH,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      user.email,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("${user.firstName} ${user.lastName}"),
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text(
            "Welcome! Please authenticate to continue.",
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(AppUserState state) {
    final title =
        (state is AppUserLoggedIn)
            ? "${state.user.firstName} ${state.user.lastName}"
            : "Welcome";

    return AppBar(title: Text(title), centerTitle: true, elevation: 1);
  }
}
