import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/bloc/movies_bloc.dart';
import 'package:tmdb/view/components/movieInputField.dart';
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
  final controller = ScrollController();
  int pageNumber = 1;
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    moviesBloc = MoviesBloc();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          offset = controller.offset;
          pageNumber++;
        });

        moviesBloc.add(GetTrending(pageNumber: pageNumber));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Movie Watcher', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => moviesBloc,
        child: BlocListener(
          bloc: moviesBloc,
          listener: (context, MoviesState state) {
            if (state is Loaded) {
              WidgetsBinding.instance!.addPostFrameCallback((_) => controller.animateTo(offset, duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut));
            }
          },
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, MoviesState state) {
              if (state is Initial) {
                moviesBloc.add(GetTrending(pageNumber: pageNumber));
                return InitialBuilder();
              } else if (state is Loading) {
                return LoadingBuilder();
              } else if (state is Loaded) {
                return LoadedBuilder(state);
              } else if (state is Error) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: showTrending(pageNumber),
                          child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "Go back to Trending",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.thumb_down_outlined,
                          size: 50,
                          color: Colors.red,
                        ),
                        const Spacer(),
                      ],
                    ),
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
    controller.dispose();
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
          const MovieInputField(),
          Container(
            padding: MediaQuery.of(context).viewInsets,
            height: MediaQuery.of(context).size.height * 0.77,
            child: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              physics: const BouncingScrollPhysics(),
              itemCount: (state is Loaded) ? state.movies.results.length + 1 : 0,
              itemBuilder: (context, index) {
                if (index < ((state is Loaded) ? state.movies.results.length : 1)) {
                  return listTile(state, index);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );

  listTile(state, index) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => launch((state is Loaded && state.movies.results[index].mediaType == "tv")
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
                      image: CachedNetworkImageProvider((state is Loaded) ? "https://image.tmdb.org/t/p/original/" + state.movies.results[index].posterPath : ""),
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (state is Loaded) ? state.movies.results[index].overview : "",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      );

  showTrending(int pageNumber) => moviesBloc.add(GetTrending(pageNumber: pageNumber));
}
