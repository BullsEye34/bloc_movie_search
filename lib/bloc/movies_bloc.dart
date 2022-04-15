import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb/models/data.dart';
import 'package:http/http.dart' as http;

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  var client = http.Client();

  MoviesBloc() : super(Initial()) {
    on<GetTrending>((event, emit) {
      // TODO: implement event handler
      emit(Loading());
      try {
        client
            .get(Uri.parse(
                "https://api.themoviedb.org/3/trending/movies/week?api_key=43236c9b4ffaa78012ee092b4e4f74d8&language=en-US&page=1&include_adult=false"))
            .then((value) {
          emit(Loaded(movies: [DataModelFromJson(value.body)]));
        });
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
    on<GetMovies>((event, emit) {
      // TODO: implement event handler
      emit(Loading());
      try {
        client
            .get(Uri.parse(
                "https://api.themoviedb.org/3/search/movie?api_key=43236c9b4ffaa78012ee092b4e4f74d8&language=en-US&page=1&include_adult=false&query=${event.title.toString()}"))
            .then((value) {
          emit(Loaded(movies: [DataModelFromJson(value.body)]));
        });
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
  }

  @override
  MoviesState get initialState => Initial();
}
