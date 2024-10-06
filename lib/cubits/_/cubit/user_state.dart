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
    List<UserModel>? users,
    bool? isAllPagesLoaded,
    QueryDocumentSnapshot? mark,
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

enum RequestStatus {
  pure,
  loading,
  failure,
  success,
}
