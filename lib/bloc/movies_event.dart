part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class GetTrending extends MoviesEvent {
  final int pageNumber;
  const GetTrending({required this.pageNumber});
  @override
  List<Object> get props => [];
}

class GetMovies extends MoviesEvent {
  final String title;
  const GetMovies({required this.title});

  @override
  List<Object> get props => [title];
}
