part of 'user_cubit.dart';

@immutable
class UserState extends Equatable {
  const UserState({
    required this.status,
    required this.users,
    required this.isAllPagesLoaded,
    this.mark,
  });

  final RequestStatus status;
  final List<UserModel> users;
  final bool isAllPagesLoaded;
  final QueryDocumentSnapshot? mark;

  UserState copyWith({
    RequestStatus? status,
    bool? isAllPagesLoaded,
    QueryDocumentSnapshot? mark,
    List<UserModel>? users,
  }) =>
      UserState(
        status: status ?? this.status,
        users: users ?? this.users,
        isAllPagesLoaded: isAllPagesLoaded ?? this.isAllPagesLoaded,
        mark: mark ?? this.mark,
      );

  @override
  List<Object?> get props => [
        status,
        users,
        isAllPagesLoaded,
        mark,
      ];
}

// final class UserInitial extends UserState {}
//
// final class UserLoading extends UserState {}
//
// class UserLoaded extends UserState {
//   final List<UserModel> users;
//   final QueryDocumentSnapshot? lastDocs;
//
//   const UserLoaded({required this.users, required this.lastDocs});
//
//   @override
//   List<Object?> get props => [users, lastDocs];
// }
//
// final class UserEmpty extends UserState {}
//
// final class UserFailed extends UserState {
//   final String message;
//
//   const UserFailed({required this.message});
// }

enum RequestStatus {
  pure,
  loading,
  failure,
  success,
}
