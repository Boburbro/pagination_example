import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  QueryDocumentSnapshot? lastData;
  UserCubit({required this.userRepository}) : super(UserInitial());

  Future getItems() async {
    emit(UserLoading());
    try {
      Map data = await userRepository.getItems();
      if (data.isNotEmpty) {
        lastData = data['lastDoc'];
        emit(UserLoaded(
          users: data['users'],
          lastDocs: data['lastDoc'],
        ));
      } else {
        emit(UserEmpty());
      }
    } catch (e) {
      emit(UserFailed(message: e.toString()));
    }
  }

  Future getMoreData() async {
    emit(UserLoading());

    try {
      if (lastData != null) {
        Map data = await userRepository.getMoreData(lastData!);
        if (data.isNotEmpty) {
          lastData = data['lastDoc'];
          emit(UserLoaded(
            users: data['users'],
            lastDocs: lastData,
          ));
        } else {
          emit(UserEmpty());
        }
      }
    } catch (e) {
      emit(UserFailed(message: e.toString()));
    }
  }
}
