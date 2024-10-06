import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UsersRepository userRepository;

  UserCubit({required this.userRepository})
      : super(
          const UserState(
            status: RequestStatus.pure,
            users: [],
            isAllPagesLoaded: false,
          ),
        );

  List<UserModel> users = [];

  Future<void> loadData() async {
    emit(state.copyWith(status: RequestStatus.loading));
    try {
      QuerySnapshot data = await userRepository.loadUsers(state.mark);
      if (data.docs.isNotEmpty) {
        List<UserModel> newPage = UserModel.fromList(data.docs);
        if (state.mark == null) {
          users = [...newPage];
        } else {
          users.addAll(newPage);
        }
        emit(
          state.copyWith(
            users: users,
            isAllPagesLoaded: newPage.length < 15,
            mark: data.docs.last,
          ),
        );
      } else {}
    } catch (error) {
      emit(state.copyWith(status: RequestStatus.failure));
    }
  }
}
