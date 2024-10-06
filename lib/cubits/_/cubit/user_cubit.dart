import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:page_nation_example/data/model/user_model.dart';
import 'package:page_nation_example/data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UsersRepository usersRepository;
  UserCubit({required this.usersRepository})
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
      QuerySnapshot data = await usersRepository.loadUsers(state.mark);
      if (data.docs.isNotEmpty) {
        List<UserModel> newUsers = UserModel.fromList(data.docs);
        if (state.mark == null) {
          users = [...newUsers];
        } else {
          users.addAll(newUsers);
        }
        state.copyWith(
          status: RequestStatus.success,
          users: users,
          mark: data.docs.last,
          isAllPagesLoaded: newUsers.length < 15,
        );
      }
    } catch (e) {
      emit(state.copyWith(status: RequestStatus.failure));
    }
  }
}
