part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class Initial extends MoviesState {}

class Loading extends MoviesState {}

class Error extends MoviesState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}

class Loaded extends MoviesState {
  final bool isGet;
  final DataModel movies;

  const Loaded({required this.movies, required this.isGet});

  @override
  List<Object> get props => [movies, true];
}
