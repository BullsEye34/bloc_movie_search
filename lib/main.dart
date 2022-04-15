import 'package:cached_network_image/cached_network_image.dart';
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
          children: const [
            Text("Please wait while we fetch your recommendations"),
          ],
        ),
      );
  LoadingBuilder() => const Center(
        child: CircularProgressIndicator(),
      );

  LoadedBuilder(MoviesState state) => Container(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
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

  listTile(state, index) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            child: Row(
          children: [
            Flexible(
              child: CachedNetworkImage(
                imageUrl: (state is Loaded)
                    ? "https://image.tmdb.org/t/p/original/" +
                        state.movies.results[index].posterPath
                    : "",
                height: 100,
                width: 100,
              ),
              /* Image.network(
                (state is Loaded)
                    ? "https://image.tmdb.org/t/p/original/" +
                        state.movies.results[index].posterPath
                    : "",
                height: 100,
                width: 100,
              ), */
              flex: 2,
            ),
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (state is Loaded) ? state.movies.results[index].name : "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (state is Loaded)
                        ? state.movies.results[index].overview
                        : "",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            )
          ],
        )),
      );
}
