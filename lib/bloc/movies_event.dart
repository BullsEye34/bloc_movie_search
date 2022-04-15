part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class GetTrending extends MoviesEvent {
  @override
  List<Object> get props => [];
}

class GetMovies extends MoviesEvent {
  final String title;
  GetMovies({required this.title});

  @override
  List<Object> get props => [title];
}
