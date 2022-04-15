import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb/models/data.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(Initial()) {
    on<MoviesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  MoviesState get initialState => Initial();
}
