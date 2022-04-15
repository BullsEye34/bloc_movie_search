import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/bloc/movies_bloc.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MoviesBloc moviesBloc;

  @override
  void initState() {
    // TODO: implement initState
    moviesBloc = MoviesBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    moviesBloc.add(GetTrending());
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Movie Watcher', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => moviesBloc,
        child: BlocListener(
          listener: (context, MoviesState state) {},
          bloc: moviesBloc,
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, MoviesState state) {
              if (state is Initial) {
                return InitialBuilder();
              } else if (state is Loading) {
                return LoadingBuilder();
              } else if (state is Loaded) {
                return LoadedBuilder(state);
              } else {
                return const Center(
                  child: Icon(
                    Icons.diamond_outlined,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                );
              }
            },
            bloc: moviesBloc,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    moviesBloc.close();
  }

  InitialBuilder() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please wait while we fetch your recommendations"),
          ],
        ),
      );
  LoadingBuilder() => Center(
        child: CircularProgressIndicator(),
      );

  LoadedBuilder(MoviesState state) => Container(
        child: ListView.builder(
          itemCount: (state is Loaded) ? state.movies.results.length : 0,
          itemBuilder: (context, index) {
            return /* ListTile(
              title: Text(
                  (state is Loaded) ? state.movies.results[index].title : ""),
              subtitle: Text((state is Loaded)
                  ? state.movies.results[index].overview
                  : ""),
              leading: Image.network(
                (state is Loaded)
                    ? "https://image.tmdb.org/t/p/original/" +
                        state.movies.results[index].posterPath
                    : "",
                height: 100,
                width: 100,
              ),
            ) */
                listTile(state, index);
          },
        ),
      );

  listTile(state, index) => Container(
          child: Row(
        children: [
          Flexible(
            child: Image.network(
              (state is Loaded)
                  ? "https://image.tmdb.org/t/p/original/" +
                      state.movies.results[index].posterPath
                  : "",
              height: 100,
              width: 100,
            ),
            flex: 2,
          ),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (state is Loaded) ? state.movies.results[index].name : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  (state is Loaded) ? state.movies.results[index].overview : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ));
}
