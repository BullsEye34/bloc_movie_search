import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb/models/data.dart';
import 'package:http/http.dart' as http;

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  var client = http.Client();
  late DataModel data;
  late DataModel _prev;

  MoviesBloc() : super(Initial()) {
    on<GetTrending>((event, emit) async {
      // TODO: implement event handler
      emit(Loading());
      if (event.pageNumber != 1) {
        _prev = data;
      }
      try {
        var response = await client.get(
            Uri.parse("https://api.themoviedb.org/3/trending/movies/week?api_key=43236c9b4ffaa78012ee092b4e4f74d8&language=en-US&page=${event.pageNumber}&include_adult=false"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            });
        data = DataModelFromJson(response.body);
        if (event.pageNumber != 1) {
          data.results.insertAll(0, _prev.results);
        }
        emit(Loaded(movies: data, isGet: false));
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
    on<GetMovies>((event, emit) async {
      // TODO: implement event handler
      emit(Loading());
      try {
        var responsee = await client.get(
            Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=43236c9b4ffaa78012ee092b4e4f74d8&language=en-US&page=1&include_adult=false&query=${event.title}"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            });
        data = DataModelFromJson(responsee.body);

        emit(Loaded(movies: data, isGet: true));
      } catch (e) {
        emit(Error(message: e.toString()));
      }
    });
  }

  @override
  MoviesState get initialState => Initial();
}
