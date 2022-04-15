import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/bloc/movies_bloc.dart';

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
