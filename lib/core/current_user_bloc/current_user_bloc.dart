import 'package:barbqtonight/core/current_user_bloc/current_user_event.dart';
import 'package:barbqtonight/core/current_user_bloc/current_user_state.dart';
import 'package:barbqtonight/features/auth/repository/auth_local_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final AuthLocalRepository _authLocalRepository;
  CurrentUserBloc(this._authLocalRepository) : super(UserInitialState()) {
    on<AddUserEvent>(_onAddUser);
    on<RemoveUserEvent>(_onRemoveUser);
  }
  Future<void> _onAddUser(
    AddUserEvent event,
    Emitter<CurrentUserState> emit,
  ) async {
    await _authLocalRepository.saveUser(event.user);
    emit(UserAddedState(event.user));
  }

  Future<void> _onRemoveUser(
    RemoveUserEvent event,
    Emitter<CurrentUserState> emit,
  ) async {
    await _authLocalRepository.removeUser();
    emit(UserInitialState());
  }
}
