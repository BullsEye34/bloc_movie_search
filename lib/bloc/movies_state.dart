part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class Initial extends MoviesState {}

class Loading extends MoviesState {}

class Loaded extends MoviesState {
  final List<DataModel> movies;

  Loaded({required this.movies});

  @override
  List<Object> get props => [movies];
}
