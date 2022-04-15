import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/bloc/movies_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            const Text('Movie Watcher', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => moviesBloc,
        child: BlocListener(
          bloc: moviesBloc,
          listener: (context, MoviesState state) {},
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, MoviesState state) {
              if (state is Initial) {
                moviesBloc.add(GetTrending());
                return InitialBuilder();
              } else if (state is Loading) {
                return LoadingBuilder();
              } else if (state is Loaded) {
                return LoadedBuilder(state);
              } else if (state is Error) {
                print(state.message);
                return const Center(
                  child: Icon(
                    Icons.diamond_outlined,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                );
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

  LoadedBuilder(MoviesState state) => ListView(
        shrinkWrap: true,
        children: [
          MovieInputField(),
          Container(
            padding: MediaQuery.of(context).viewInsets,
            height: MediaQuery.of(context).size.height * 0.77,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: (state is Loaded) ? state.movies.results.length : 0,
              itemBuilder: (context, index) {
                return listTile(state, index);
              },
            ),
          ),
        ],
      );

  listTile(state, index) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => launch((state is Loaded &&
                  state.movies.results[index].mediaType == "tv")
              ? "https://www.themoviedb.org/tv/${state.movies.results[index].id}"
              : "https://www.themoviedb.org/movie/${state.movies.results[index].id}"),
          child: Container(
              //height: 120,
              child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider((state is Loaded)
                          ? "https://image.tmdb.org/t/p/original/" +
                              state.movies.results[index].posterPath
                          : ""),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                flex: 2,
              ),
              const SizedBox(
                width: 20,
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
        ),
      );
}

class MovieInputField extends StatefulWidget {
  const MovieInputField({Key? key}) : super(key: key);

  @override
  State<MovieInputField> createState() => _MovieInputFieldState();
}

class _MovieInputFieldState extends State<MovieInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        onSubmitted: submitSearch,
        decoration: InputDecoration(
          hintText: "Enter Movie Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  submitSearch(String title) {
    MoviesBloc blocProvider = BlocProvider.of<MoviesBloc>(context);
    blocProvider.add(GetMovies(title: title));
  }
}
