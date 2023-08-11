// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_event_bloc.dart';

class RegisterEventState extends Equatable {
  final String name;


  const RegisterEventState({
    required this.name,

  });

  @override
  List<Object?> get props => [
        name,

      ];

  RegisterEventState copyWith({
    String? name,
  }) {
    return RegisterEventState(
      name: name ?? this.name,
    );
  }
}
