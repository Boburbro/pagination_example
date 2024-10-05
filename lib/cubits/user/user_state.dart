part of 'user_cubit.dart';

@immutable
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final QueryDocumentSnapshot? lastDocs;

  const UserLoaded({required this.users, required this.lastDocs});

  @override
  List<Object?> get props => [users, lastDocs];
}

final class UserEmpty extends UserState {}

final class UserFailed extends UserState {
  final String message;

  const UserFailed({required this.message});
}
